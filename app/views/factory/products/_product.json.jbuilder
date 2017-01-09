json.extract! product, :id, :name, :created_at, :updated_at
json.url factory_product_url(product, format: :json)
