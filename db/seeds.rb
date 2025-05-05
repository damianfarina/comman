# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

unless User.any?
  User.create! email_address: "admin@commanapp.dev", password: SecureRandom.hex(16), name: "Admin User"
end

end

unless Discount.any?
  Discount.create!(discount_type: "cash", percentage: 10.0)
  Discount.create!(discount_type: :client_type, client_type: :regular, percentage: 10.0)
  Discount.create!(discount_type: :client_type, client_type: :hardware_store, percentage: 11.0)
  Discount.create!(discount_type: :client_type, client_type: :distributor, percentage: 12.0)
end
