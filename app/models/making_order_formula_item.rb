class MakingOrderFormulaItem < ApplicationRecord
  belongs_to :formula_item
  belongs_to :formula_element
  belongs_to :making_order_formula

  before_save :calculate_consumed_stock
  after_create :take_formula_element_stock
  after_update :update_formula_element_stock
  after_destroy :give_back_formula_element_stock

  private

    def calculate_consumed_stock
      self.consumed_stock = self.making_order_formula.making_order.total_weight * self.proportion / 100.0
    end

    def give_back_formula_element_stock
      return if self.formula_item.nil?
      return if self.formula_item.formula_element.nil?

      current_stock = self.formula_item.formula_element.current_stock + self.consumed_stock
      self.formula_item.formula_element.update current_stock: current_stock
    end

    def take_formula_element_stock
      current_stock = self.formula_item.formula_element.current_stock - self.consumed_stock
      self.formula_item.formula_element.update current_stock: current_stock
    end

    def update_formula_element_stock
      return unless self.consumed_stock_previously_changed?
      return if self.formula_item.nil?
      return if self.formula_item.formula_element.nil?

      diff = self.consumed_stock_previously_was - self.consumed_stock
      current = self.formula_item.formula_element.current_stock + diff
      self.formula_item.formula_element.update current_stock: current
    end
end

# == Schema Information
#
# Table name: making_order_formula_items
#
#  id                      :bigint           not null, primary key
#  consumed_stock          :decimal(, )
#  formula_element_name    :string
#  proportion              :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  formula_element_id      :integer
#  formula_item_id         :integer
#  making_order_formula_id :integer
#
