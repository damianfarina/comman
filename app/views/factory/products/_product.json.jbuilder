json.extract! product, :id, :name, :formula_id, :shape, :size, :weight, :pressure
json.url factory_product_url(product, format: :json)
