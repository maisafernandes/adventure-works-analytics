-- Todo pedido da dim_sales_order precisa ter ao menos um motivo (ou o membro 'Not informed') na ponte.
select
    dim_sales_order.sales_order_sk
from {{ ref('dim_sales_order') }} as dim_sales_order
left join {{ ref('bridge_sales_order_reason') }} as bridge
    on dim_sales_order.sales_order_sk = bridge.sales_order_sk
where bridge.sales_order_sk is null
