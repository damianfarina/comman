class ProductionMonth < ActiveRecord::Base
  attr_accessible :year, :month, :production

  validates :year, :month, :production, :presence => true

  def self.data_for_chart
    data_year = []
    self.order(:year).group(:year).pluck(:year).each do |year|
      data_month = []
      self.where(:year => year).order(:month).each do |month|
        data_month << { :year => month.year, :month => month.month, :production => month.production.to_s }
      end
      data_year << { :name => year.to_s, :data => data_month }
    end
    data_year
  end

  def self.generate_production_levels
    MakingOrderFormulaItem.find_each do |item|
      year = item.created_at.to_date.year
      month = item.created_at.to_date.month
      production_month = ProductionMonth.find_or_initialize_by_year_and_month(year, month)
      production_month.production = production_month.production + item.consumed_stock
      production_month.save!
    end
  end
end
