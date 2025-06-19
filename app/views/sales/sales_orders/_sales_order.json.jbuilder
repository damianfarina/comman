json.extract! sales_order, :id, :client_id, :status, :confirmed_at, :fulfilled_at, :cancelled_at, :total_price, :comments_plain_text, :cash_discount_percentage, :client_discount_percentage, :created_at, :updated_at
json.url sales_order_url(sales_order, format: :json)
