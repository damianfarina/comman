module Factory::FormulasHelper
  def formulas_for_select
    Formula.select([:id, :name]).map{|f| [f.name, f.id]}
  end
  
  def formula_elements_for_select
    FormulaElement.select([:id, :name]).map{|f| [f.name, f.id]}
  end
end
