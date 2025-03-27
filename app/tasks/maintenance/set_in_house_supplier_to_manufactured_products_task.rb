# frozen_string_literal: true

module Maintenance
  class SetInHouseSupplierToManufacturedProductsTask < MaintenanceTasks::Task
    def collection
      Product.all
    end

    def process(product)
      return if product.productable.is_a?(PurchasedProduct)
      return if product.suppliers.where(in_house: true).any?

      product.supplier_products.create!(supplier: Supplier.in_house)
    end

    def count
      Product.all
    end
  end
end
