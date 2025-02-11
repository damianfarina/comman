Discount.find_or_create_by!(discount_type: :cash, percentage: 5.0)
Discount.find_or_create_by!(discount_type: :client_type, client_type: :regular, percentage: 10.0)
Discount.find_or_create_by!(discount_type: :client_type, client_type: :distributor, percentage: 15.0)
Discount.find_or_create_by!(discount_type: :client_type, client_type: :hardware_store, percentage: 20.0)
