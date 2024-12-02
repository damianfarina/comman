class Formula < ApplicationRecord
  has_many :formula_items, -> { order(id: :desc) }, dependent: :destroy
  has_many :formula_elements, through: :formula_items

  accepts_nested_attributes_for :formula_items, allow_destroy: true

  validates :abrasive, :grain, :hardness, :porosity, :alloy, :name, :formula_items, presence: true
  validate :name_is_unique, if: -> { name.present? }
  validate :items_proportion_is_one_hundred, if:  -> { self.formula_items.any? }

  before_validation :set_name

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "abrasive", "grain", "hardness", "porosity", "alloy" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private
    def items_proportion_is_one_hundred
      difference = 100.0
      difference = self.formula_items.inject(difference) do |result, item|
        unless item.marked_for_destruction?
          result -= (item.proportion || 0)
        end
        result
      end

      return if difference.abs < 0.01

      errors.add(
        :base,
        I18n.t(
          :proportion_must_be_one_hundred,
          scope: [ :activerecord, :errors, :models, :formula ],
          difference: difference.round(3),
        )
      )

      throw :abort
    end

    def set_name
      self.name = "#{abrasive}#{grain}#{hardness}#{porosity}#{alloy}".gsub(" ", "")
    end

    def name_is_unique
      other_formula = Formula.find_by_name(self.name)
      if other_formula && other_formula.id != self.id
        errors.add(
          :base,
          I18n.t(
            :name_must_be_unique,
            scope: [ :activerecord, :errors, :models, :formula ],
            other_formula_id: other_formula.id,
            other_formula_name: other_formula.name,
          )
        )

        throw :abort
      end
    end
end

# == Schema Information
#
# Table name: formulas
#
#  id         :integer          not null, primary key
#  name       :string
#  abrasive   :string
#  grain      :string
#  hardness   :string
#  porosity   :string
#  alloy      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
