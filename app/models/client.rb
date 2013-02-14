class Client < ActiveRecord::Base
  attr_accessible :name, :address
  validates :name, :address, :presence => true

  scope :name_or_id_contains, lambda { |part| where('id = ? OR UPPER(name) like UPPER(?)', get_id_from_search(part), "%#{part}%") }

private
  
  def self.get_id_from_search(search)
    return 0 if search.blank?
    search = search.strip
    return 0 if search[0] != '#'
    return search.gsub('#', '').to_i
  end
end
