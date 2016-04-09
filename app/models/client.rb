class Client < ApplicationRecord
  validates :name, :address, :zip_code, :balance, :admission_date, :client_type_id, :presence => true

  scope :name_or_id_contains, lambda { |part| where('id = ? OR UPPER(name) like UPPER(?)', get_id_from_search(part), "%#{part}%").order('name') }

  belongs_to :client_type
  delegate :name, :to => :client_type, :prefix => true, :allow_nil => true

  COUNTRIES = [
    'Argentina',
    'Chile',
    'Uruguay',
    'Brasil'
  ]

private

  def self.get_id_from_search(search)
    return 0 if search.blank?
    search = search.strip
    return 0 if search[0] != '#'
    return search.gsub('#', '').to_i
  end
end
