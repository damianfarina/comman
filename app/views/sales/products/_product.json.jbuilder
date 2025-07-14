json.extract! product, :id, :name, :current_stock, :comments, :price

json.url sales_product_url(product, format: :json)
