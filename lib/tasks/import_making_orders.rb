require 'csv'

class ImportMakingOrders

  def self.import(file)
    inserts = ""
    CSV.foreach(file) do |row|
      inserts << "BEGIN;\n"

      begin
        inserts << "INSERT INTO making_orders (id, total_weight, weight_per_round, rounds_count, created_at, updated_at, mixer_capacity, state) VALUES(#{row[0]},#{row[31]},#{row[32]},#{row[33]},'#{row[1]} 12:00:00','#{row[1]} 12:00:00',#{row[32].to_f.ceil},1);\n"
        formula = get_formula(row)
        inserts << "INSERT INTO making_order_formulas (formula_id, making_order_id, formula_name, created_at, updated_at, formula_abrasive, formula_grain, formula_hardness, formula_porosity, formula_alloy) VALUES (#{formula[:id]}, #{row[0]}, '#{formula[:name]}', '#{row[1]} 12:00:00', '#{row[1]} 12:00:00', '#{formula[:abrasive]}', '#{formula[:grain]}', '#{formula[:hardness]}', '#{formula[:porosity]}', '#{formula[:alloy]}');\n"

        get_formula_items(row, formula[:id]).each do |item|
          inserts << "INSERT INTO making_order_formula_items (making_order_formula_id, formula_item_id, formula_element_id, formula_element_name, proportion, created_at, updated_at, consumed_stock) VALUES ((SELECT MAX(id) FROM making_order_formulas), #{item[:formula_item_id]}, #{item[:formula_element_id]}, '#{item[:formula_element_name]}', #{item[:proportion]}, '#{row[1]} 12:00:00', '#{row[1]} 12:00:00', #{item[:consumed_stock]});\n"
        end

        get_order_items(row).each do |item|
          inserts << "INSERT INTO making_order_items (making_order_id, product_id, quantity, product_name, product_shape, product_size, product_weight, product_pressure, created_at, updated_at) VALUES (#{row[0]}, NULL, #{item[:quantity]}, '#{item[:name]}', '#{item[:shape]}', '#{item[:size]}', #{item[:weight].to_f.round(5)}, '#{item[:pressure]}', '#{row[1]} 12:00:00', '#{row[1]} 12:00:00');\n"
        end
      rescue Exception => e
        puts row[0]
        raise e
      end

      inserts << "COMMIT;\n"
    end

    puts inserts
  end

  def self.get_formula(row)
    formula = Formula.find_by_name("#{row[2]}#{row[3]}#{row[4]}#{row[5]}#{row[6]}".upcase.gsub(' ', ''))
    formula_id = formula.nil? ? "NULL" : formula.id
    {
      :id => formula_id,
      :name => "#{row[2]}#{row[3]}#{row[4]}#{row[5]}#{row[6]}".upcase.gsub(' ', ''),
      :abrasive => row[2].upcase.gsub(' ', ''),
      :grain => row[3].upcase.gsub(' ', ''),
      :hardness => "#{row[4]}".upcase.gsub(' ', ''),
      :porosity => row[5].upcase.gsub(' ', ''),
      :alloy => row[6].upcase.gsub(' ', '')
    }
  end

  def self.get_formula_items(row, formula_id)
    items = []
    formula = Formula.where(:id => formula_id).first || Formula.new
    (7..30).step(2) do |i|
      next if row[i].blank?
      element = FormulaElement.where("UPPER(name) = ?", row[i].upcase.gsub(' ', '')).first
      if element.nil?
        element_id = "NULL"
        formula_item_id = "NULL"
      else
        element_id = element.id
        formula_item = formula.formula_items.where(:id => element.id).first
        formula_item_id = formula_item.nil? ? "NULL" : formula_item.id
      end
      items << {
        :formula_item_id => formula_item_id,
        :formula_element_id => element_id,
        :formula_element_name => row[i],
        :proportion => (row[i+1].to_f * 100.0).round(5),
        :consumed_stock => (row[31].to_f * row[i+1].to_f).round(5)
      }
    end
    items
  end

  def self.get_order_items(row)
    items = []
    (34..103).step(5) do |i|
      next if row[i].blank? or row[i] == '0'
      items << {
        :quantity => row[i+4].to_i,
        :name => "#{row[i]}#{row[i+1]}#{row[i+3]}",
        :shape => "#{row[i]}",
        :size => "#{row[i+1]}",
        :weight => row[i+2].to_f.round(3),
        :pressure => "#{row[i+3]}"
      }
    end
    items
  end
end