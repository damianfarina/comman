# frozen_string_literal: true

module Maintenance
  class SetProductPriceTo0WhenNullTask < MaintenanceTasks::Task
    def collection
      Product.all
    end

    def process(product)
      return if product.price.present?

      product.update_column(:price, 0)
    end

    def count
      Product.count
    end
  end
end
