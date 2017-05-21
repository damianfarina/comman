class Factory::DashboardController < Factory::FactoryController
  layout "factory"

  def index
    @production_monthly = Reporting.production_monthly
    @production_yearly = Reporting.production_yearly
  end
end
