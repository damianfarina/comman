module Factory::DashboardHelper

  def flat_dates_to_nested_dates(dates)
    nested = []
    dates.each do |date_production|
      year_index = find_year_index(date_production['year'], nested)
      year_index = nested.length if year_index.nil?

      nested[year_index] = nested[year_index] || {}
      nested[year_index][:name] = date_production['year']
      nested[year_index][:data] = nested[year_index][:data] || []
      nested[year_index][:data] << {
        year: date_production['year'],
        month: date_production['month'],
        production: date_production['weight'].to_f
      }
    end

    nested
  end

private

  def find_year_index(year, years)
    years.index { |local_year| local_year[:name] == year }
  end

end
