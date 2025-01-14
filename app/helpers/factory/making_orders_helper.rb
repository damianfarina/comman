module Factory::MakingOrdersHelper
  def products_for_select
    Product.select([ :id, :name ]).map { |f| [ f.name, f.id ] }
  end

  def formula_item_weight_per_round(item_proportion, weight)
    number_with_precision(item_proportion / 100.0 * weight, precision: 3)
  end
end
