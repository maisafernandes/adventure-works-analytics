# Adventure Works Analytics

Projeto de Analytics Engineering da Adventure Works, fabricante de bicicletas com mais de 500 produtos, cerca de 20 mil clientes e 31 mil pedidos. O dbt transforma os dados brutos do PostgreSQL em um modelo estrela de vendas, e um painel em Power BI consome esse modelo para responder às perguntas da diretoria comercial.

O ponto central do projeto é a **confiança nos números**: toda a camada de transformação é testada, e um teste específico confere a receita bruta de 2011 contra o valor auditado pela contabilidade ($12.646.112,16).

## Stack

| Componente | Versão ou detalhe |
|---|---|
| Banco de dados | PostgreSQL (local), banco `Adventureworks` |
| Transformação | dbt-core 1.12 com dbt-postgres 1.11 |
| Pacotes dbt | `dbt-labs/dbt_utils` (de 1.1 até antes da 2.0) |
| BI | Power BI Desktop, conectado ao schema `public` |

## Estrutura do projeto

```
models/
  staging/        14 views: uma por tabela de origem, com renomeação e casting de tipos
  intermediate/   3 views: int_customer, int_location, int_product
  marts/          9 tabelas: fact_sales, bridge_sales_order_reason e 7 dimensões dim_*
tests/            3 testes singulares (valores e conciliação)
dbt_project.yml   staging e intermediate como view, marts como table
packages.yml      dependência do dbt_utils
```

## Modelo de dados

Modelo estrela com uma fato no grão do **item do pedido** e uma tabela ponte para os motivos de venda.

| Tabela | Tipo | Grão | Origem |
|---|---|---|---|
| `fact_sales` | Fato | Item do pedido | `sales.salesorderdetail`, `sales.salesorderheader` |
| `dim_sales_order` | Dimensão | Pedido | `sales.salesorderheader` |
| `bridge_sales_order_reason` | Ponte | Pedido por motivo | `sales.salesorderheadersalesreason` |
| `dim_sales_reason` | Dimensão | Motivo de venda | `sales.salesreason` |
| `dim_date` | Dimensão | Dia | Calendário gerado (2011 a 2014) |
| `dim_customer` | Dimensão | Cliente | `sales.customer`, `person.person`, `sales.store` |
| `dim_product` | Dimensão | Produto | `production.product`, `production.productsubcategory`, `production.productcategory` |
| `dim_location` | Dimensão | Endereço | `person.address`, `person.stateprovince`, `sales.salesterritory` |
| `dim_credit_card` | Dimensão | Cartão de crédito | `sales.creditcard` |

O caminho do filtro entre motivo de venda e fato é:

```
dim_sales_reason -> bridge_sales_order_reason -> dim_sales_order -> fact_sales
```

### Decisões de modelagem

- **Sem duplicação de receita.** Um pedido pode ter vários motivos de venda. Em vez de ligar o motivo direto à fato (o que duplicaria os itens), a ponte liga pedido e motivo. A fato tem exatamente uma linha por `sales_order_detail_id`.
- **Chaves substitutas (SK).** Cada dimensão tem uma `*_sk`, gerada como hash MD5 da chave natural com `dbt_utils.generate_surrogate_key`. A chave natural continua disponível como atributo.
- **Chaves estrangeiras (FK).** A fato guarda as FKs com o mesmo nome da SK da dimensão (por exemplo, `customer_sk`). A chave única da fato é `sales_order_detail_sk`.
- **Valores ausentes.** `dim_credit_card` e `dim_sales_reason` têm o membro **"Not informed"** com identificador `-1`. Pedidos sem cartão ou sem motivo apontam para ele, e nenhuma venda sai dos filtros.
- **Receitas na fato.** `gross_revenue` (quantidade vezes preço), `discount_amount` e `revenue` (receita líquida, já abatendo o desconto).
- **Categorias.** Produtos sem subcategoria na origem (peças e subconjuntos) aparecem como "Sem categoria" e "Sem subcategoria".

## Como executar

### 1. Pré-requisitos

- PostgreSQL com o banco AdventureWorks carregado. Instruções e scripts em [AdventureWorks-for-Postgres](https://github.com/lorint/AdventureWorks-for-Postgres).
- Python (o projeto foi executado com a versão 3.12), com `dbt-core` e `dbt-postgres` instalados.

### 2. Perfil de conexão

Crie o perfil `adventure_works` em `~/.dbt/profiles.yml`. Não versione esse arquivo, porque ele contém a senha.

```yaml
adventure_works:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: <usuario>
      password: <senha>
      dbname: Adventureworks
      schema: public
      threads: 4
```

### 3. Executar

```bash
dbt deps      # instala o dbt_utils
dbt debug     # confere a conexão
dbt build     # roda modelos e testes, na ordem do DAG
```

Para gerar e abrir a documentação com a linhagem de dados:

```bash
dbt docs generate
dbt docs serve
```

## Testes e qualidade

O `dbt build` executa 26 modelos e 122 testes de dados. Todos passam.

| Teste | Onde | O que garante |
|---|---|---|
| `unique` e `not_null` | Chaves das tabelas de origem, chaves primárias das dimensões e da ponte, chave única da fato | Sem duplicidade e sem chaves nulas |
| `relationships` | Cada FK da fato e da ponte | Integridade referencial com as dimensões |
| `accepted_values` | `order_status` em `dim_sales_order` | Status restrito aos códigos 1 a 6 |
| `not_null` | Colunas de valor da fato | Nenhum item sem valor |
| Singular | `assert_gross_sales_2011_matches_audit` | Receita bruta de 2011 igual a $12.646.112,16 |
| Singular | `assert_fact_sales_matches_source` | Mesmas linhas e mesma receita bruta da tabela de itens da origem |
| Singular | `assert_every_order_has_reason_in_bridge` | Todo pedido tem ao menos um motivo (ou "Not informed") na ponte |

### Valores de referência

Valores sem filtros, úteis para validar o painel depois de cada atualização:

| Indicador | Valor |
|---|---|
| Receita bruta | $110.373.889,31 |
| Receita líquida | $109.846.381,40 |
| Pedidos | 31.465 |
| Itens vendidos | 274.914 |
| Ticket médio (líquida por pedido) | $3.491,07 |
| Receita bruta de 2011 (auditada) | $12.646.112,16 |

## Consumo no Power BI

O painel importa as tabelas do schema `public`. As relações são de um para muitos, ligadas pelas chaves substitutas. A relação entre `bridge_sales_order_reason` e `dim_sales_order` precisa ter **filtro cruzado nos dois sentidos**, para que o motivo de venda alcance a fato. Como a fato não duplica linhas, as medidas financeiras são somas simples (`SUM`) e o ticket médio é a receita líquida dividida pelos pedidos distintos.

## Fluxo de trabalho

As mudanças entram pela `main` por Pull Request, uma branch por tema (por exemplo, `feature/staging-casting` e `feature/surrogate-keys`). Cada branch é validada com `dbt build` antes do merge.

## Referências

- [Documentação do dbt](https://docs.getdbt.com/docs/introduction)
- [dbt_utils](https://github.com/dbt-labs/dbt-utils)
- [AdventureWorks para PostgreSQL](https://github.com/lorint/AdventureWorks-for-Postgres)
