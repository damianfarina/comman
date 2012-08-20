require 'csv'

class ImportFormulas

  def self.import(file)
    csv = CSV.open(file, 'r')
    csv.each_with_index do |row, index|
      #print "[#{index+1}] "
      formula = Formula.new
      formula.id = row[0]
      formula.abrasive = row[1]
      formula.grain = row[2]
      formula.hardness = row[3]
      formula.porosity = row[4]
      formula.alloy = row[5]
      (6..29).step(2).each do |formula_element_index|
        next if row[formula_element_index].empty?
        element = FormulaElement.find_or_create_by_name(row[formula_element_index].gsub(' ', '').upcase)
        item = FormulaItem.new
        item.formula = formula
        item.formula_element = element
        item.proportion = (row[formula_element_index + 1].to_f * 100).round(5)
        formula.formula_items << item
      end
      normalize_formula_item(formula)

      unless formula.save
        if Formula.where(:name => formula.name).exists?
          puts "Ya existe la formula #{formula.id}:#{formula.name}, es la #{Formula.where(:name => formula.name).first.id}"
        else
          raise "#{formula.errors.full_messages}"
        end
      end
    end
  end

  def self.normalize_formula_item(formula)
    difference = (formula.formula_items.inject(100.0) { |result, item| result - item.proportion }).round(5)
    formula.formula_items.each do |item|
      item.proportion = item.proportion + (item.proportion * difference / 100)
    end

    formula.formula_items.each do |item|
      item.proportion = item.proportion.round(5)
    end
  end
end
