json.extract! supplier, :id, :address, :country, :email, :name, :phone, :province, :tax_type, :tax_identification, :zipcode, :comments_plain_text
json.url office_supplier_url(supplier, format: :json)
