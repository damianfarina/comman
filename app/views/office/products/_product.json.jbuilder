json.extract! product, :id, :name, :min_stock, :max_stock, :current_stock, :description, :productable_id, :productable_type

json.url office_product_url(product, format: :json)
