json.extract! user, :id, :name, :email_address, :created_at, :updated_at
json.url office_user_url(user, format: :json)
