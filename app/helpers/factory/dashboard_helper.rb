module Factory::DashboardHelper
  def production_levels_per_year
    MakingOrders.all.each do |m|

    end
  end

  def years
    (2011..Date.today.year).to_a
  end
end
