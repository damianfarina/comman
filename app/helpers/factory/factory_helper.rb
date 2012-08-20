module Factory::FactoryHelper
  def is_formula_elements_active?
    params[:controller].match('factory/formula_elements.*')
  end
  def is_products_active?
    params[:controller].match('factory/products.*')
  end
  def is_formulas_active?
    params[:controller].match('factory/formulas')
  end
  def is_making_orders_active?
    params[:controller].match('factory/making_orders')
  end
end
