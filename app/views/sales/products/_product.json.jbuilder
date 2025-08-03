json.extract! product, :id, :name, :current_stock, :comments, :price
json.stock_level_color stock_level_color(product.stock_level)

json.url sales_product_url(product, format: :json)
