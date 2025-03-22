json.extract! product, :id, :name, :min_stock, :max_stock, :current_stock, :comments

json.manufactured_product do
  json.id product.manufactured_product.id
  json.formula_id product.manufactured_product.formula_id
  json.shape product.manufactured_product.shape
  json.size product.manufactured_product.size
  json.weight product.manufactured_product.weight
  json.pressure product.manufactured_product.pressure
end
json.url factory_product_url(product, format: :json)
