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

      result = ActiveRecord::Base.connection.exec_query(sql).to_a
      incomplete_year = result.find{|row| row['year'] == Date.today.year.to_s }

      return result unless incomplete_year

      last_year_weight = guess_incomplete_data_from_last_year
      incomplete_year['weight'] = (
        incomplete_year['weight'].to_f + last_year_weight
      ).to_s

      result
    end

  private

    def guess_incomplete_data_from_last_year
      same_month_last_year = DateTime.now - 12.months
      end_of_last_year = same_month_last_year.end_of_year
      sql = <<-SQL
        SELECT cast(extract(YEAR FROM created_at) AS int) AS year,
          sum(consumed_stock) as weight
        FROM making_order_formula_items
        WHERE making_order_formula_items.created_at > '#{same_month_last_year}'
          AND making_order_formula_items.created_at <= '#{end_of_last_year}'
        GROUP BY 1
        ORDER BY year;
      SQL

      guessed_from_last_year = ActiveRecord::Base.connection.exec_query(sql).to_a

      return 0.0 unless guessed_from_last_year.any?

      guessed_from_last_year.first['weight'].to_f
    end
  end

end
