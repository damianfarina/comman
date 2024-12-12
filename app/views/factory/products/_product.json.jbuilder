json.extract! product, :id, :name, :price, :formula_id, :shape, :size, :weight, :pressure, :created_at, :updated_at
json.url factory_product_url(product, format: :json)
