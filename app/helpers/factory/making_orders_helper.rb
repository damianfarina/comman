module Factory::MakingOrdersHelper
  def formula_item_weight_per_round(item_proportion, weight)
    number_with_precision(item_proportion / 100.0 * weight)
  end
end
