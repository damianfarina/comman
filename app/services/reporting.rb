class Reporting

  class << self
    def production_monthly
      sql = <<-SQL
        SELECT cast(extract(MONTH FROM created_at) AS int) AS month,
          cast(extract(YEAR FROM created_at) AS int) AS year,
          sum(consumed_stock) as weight
        FROM making_order_formula_items
        GROUP BY 1,2
        ORDER BY year, month;
      SQL

      ActiveRecord::Base.connection.exec_query(sql).to_a
    end

    def production_yearly
      sql = <<-SQL
        SELECT cast(extract(YEAR FROM created_at) AS int) AS year,
          sum(consumed_stock) as weight
        FROM making_order_formula_items
        GROUP BY 1
        ORDER BY year;
      SQL

      ActiveRecord::Base.connection.exec_query(sql).to_a
    end
  end

end
