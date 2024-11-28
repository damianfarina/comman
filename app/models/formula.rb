class Formula < ApplicationRecord
  has_many :formula_items, -> { order(id: :desc) }, dependent: :destroy
  has_many :formula_elements, through: :formula_items

  validates :abrasive, :grain, :hardness, :porosity, :alloy, :name, presence: true # :formula_items
  validate :name_is_unique, if: -> { name.present? }

  before_validation :set_name

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "abrasive", "grain", "hardness", "porosity", "alloy" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

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
