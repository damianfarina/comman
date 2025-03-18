# frozen_string_literal: true

module Maintenance
  class SplitProductIntoPolymorphicAssociationsTask < MaintenanceTasks::Task
    def collection
      Product.all
    end

    def process(product)
      return if product.productable.present?

      product.productable = ManufacturedProduct.build(
        formula: product.formula,
        pressure: product.pressure,
        shape: product.shape,
        size: product.size,
        weight: product.weight
      )
      product.save!
    end

    def count
      Product.count
    end
  end
end
