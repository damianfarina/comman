class User < ApplicationRecord
  include Auditable, Coverable

  auditable

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, :email_address, presence: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email_address, uniqueness: true

  before_validation :normalize_email_address
  before_validation :set_initial_password, on: :create

  def normalize_email_address
    self.email_address = email_address.strip.downcase if email_address.present?
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email_address created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def set_initial_password
    self.password = SecureRandom.alphanumeric(16) if password_digest.blank?
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email_address   :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
