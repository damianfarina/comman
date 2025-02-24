class Formula < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :formula_items, -> { order(id: :asc) }, dependent: :destroy
  has_many :formula_elements, through: :formula_items
  has_many :making_order_formulas, dependent: :nullify

  accepts_nested_attributes_for :formula_items, allow_destroy: true, reject_if: :all_blank

  validates :abrasive, :grain, :hardness, :porosity, :alloy, :name, :formula_items, presence: true
  validate :name_is_unique, if: -> { name.present? }
  validate :no_duplicated_formula_elements
  validate :items_proportion_is_one_hundred, if: -> { self.formula_items.any? }

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

      if difference.abs >= 0.01
        formula_items.each do |item|
          item.errors.add(:base,
            I18n.t(:proportion_must_be_one_hundred, scope: [ :activerecord, :errors, :models, :formula ])
          )
        end

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
    end

    def set_name
      self.name = "#{abrasive}#{grain}#{hardness}#{porosity}#{alloy}".gsub(" ", "")
    end

    def no_duplicated_formula_elements
      element_ids = formula_items.reject(&:marked_for_destruction?).map(&:formula_element_id)
      duplicates = element_ids.select { |id| element_ids.count(id) > 1 }.uniq

      if duplicates.any?
        formula_items.each do |item|
          if duplicates.include?(item.formula_element_id) && !item.marked_for_destruction?
          item.errors.add(:base, I18n.t(:duplicated_formula_elements, scope: [ :activerecord, :errors, :models, :formula ]))
          end
        end
        errors.add(:base, I18n.t(:duplicated_formula_elements, scope: [ :activerecord, :errors, :models, :formula ]))
        throw :abort
      end
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
#  id         :bigint           not null, primary key
#  abrasive   :string
#  alloy      :string
#  grain      :string
#  hardness   :string
#  name       :string
#  porosity   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
