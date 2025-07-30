json.extract! order, :id, :client_id, :status, :confirmed_at, :fulfilled_at, :canceled_at, :total_price, :comments_plain_text, :cash_discount_percentage, :client_discount_percentage, :created_at, :updated_at
json.url sales_order_url(order, format: :json)
