class ManufacturedProduct < ApplicationRecord
  include Productable

  belongs_to :formula
  has_many :formula_elements, through: :formula

  delegate :name, to: :formula, prefix: true, allow_nil: true

  validates :formula, presence: true
  validates :pressure, :shape, :size, :weight, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    [ "formula_id", "id", "pressure", "shape", "size", "updated_at", "weight" ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[formula]
  end

  def name
    if shape.present? && size.present? && formula_name.present? && pressure.present?
      combined_name = [ shape, size, formula_name, pressure ].join
      combined_name.gsub(" ", "")
    end
  end
end

# == Schema Information
#
# Table name: manufactured_products
#
#  id         :bigint           not null, primary key
#  pressure   :string
#  shape      :string
#  size       :string
#  weight     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  formula_id :bigint
#
# Indexes
#
#  index_manufactured_products_on_formula_id  (formula_id)
#
# Foreign Keys
#
#  fk_rails_...  (formula_id => formulas.id)
#
