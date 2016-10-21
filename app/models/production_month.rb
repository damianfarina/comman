class ProductionMonth < ActiveRecord::Base
  attr_accessible :year, :month, :production

  validates :year, :month, :production, :presence => true

  def self.data_for_chart
    data_year = []
    self.order(:year).group(:year).pluck(:year).each do |year|
      data_month = []
      self.where(:year => year).order(:month).each do |month|
        data_month << { :year => month.year, :month => month.month, :production => month.production }
      end
      data_year << { :name => year.to_s, :data => data_month }
    end
    data_year
  end

  def self.weight_per_year
    data_year = []
    self.where('year < ?', Date.today.year).order(:year).group(:year).pluck(:year).each do |year|
      production = self.where(:year => year).order(:month).reduce(0) do |sum, month|
        sum + month.production
      end
      data_year << production
      puts "#{year}: #{production}"
    end

    production = self.where(:year => Date.today.beginning_of_year.yesterday.year) \
      .order(:month).reduce(0) do |sum, month|
        current_month = self.where(:year => Date.today.year).where(month: month.month).first
        if current_month
          sum + current_month.production
        else
          sum + month.production
        end
      end
    data_year << production

    data_year
  end

  def self.generate_production_levels
    ProductionMonth.delete_all
    MakingOrderFormulaItem.find_each do |item|
      year = item.created_at.to_date.year
      month = item.created_at.to_date.month
      production_month = ProductionMonth.find_or_initialize_by_year_and_month(year, month)
      production_month.production = production_month.production + item.consumed_stock
      production_month.save!
    end
  end
end
