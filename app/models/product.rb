class Product < ApplicationRecord
  belongs_to :formula, dependent: :destroy
  has_many :formula_elements, through: :formula
  has_many :making_order_items, dependent: :nullify

  delegate :name, to: :formula, prefix: true, allow_nil: true

  scope :by_formula, ->(formula_id) { where(formula_id: formula_id) }

  validates :name, :shape, :size, :pressure, :price, :weight, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, unless: -> { name.blank? }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, unless: -> { name.blank? }
  validate :name_is_unique, unless: -> { name.blank? }

  before_validation :set_name

  def self.ransackable_attributes(auth_object = nil)
    %w[id name pressure price shape size weight]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[formula]
  end

  private
    def set_name
      if shape.present? && size.present? && formula_name.present? && pressure.present?
        combined_name = [ shape, size, formula_name, pressure ].join
        self.name = combined_name.gsub(" ", "")
      end
    end

    def name_is_unique
      other_product = Product.where.not(id: id).find_by(name: name)
      if other_product.present?
        errors.add(:base, I18n.t(:name_must_be_unique, scope: [ :activerecord, :errors, :models, :product ], other_product_id: other_product.id, other_product_name: other_product.name))
      end
    end
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  pressure   :string
#  price      :decimal(, )
#  shape      :string
#  size       :string
#  weight     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  formula_id :integer
#
