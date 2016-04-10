class ProductSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :formula_id,
    :shape,
    :size,
    :weight,
    :pressure,
    :price,
    :created_at,
    :updated_at
end
