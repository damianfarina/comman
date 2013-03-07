require 'csv'

class ImportProducts

  def self.import(file)
    csv = CSV.open(file, 'r')
    csv.each_with_index do |row, index|

      product = Product.new
      product.id = row[0]
      product.shape = row[1]
      product.size = row[2]
      product.price = row[3].gsub(".", "@").gsub(",", ".").gsub("@", ",")
      product.formula_id = row[4]
      product.weight = row[5].gsub(".", "@").gsub(",", ".").gsub("@", ",")
      product.pressure = row[6]

      unless product.save
        if Product.where(:name => product.name).exists?
          puts "El #{product.id} esta repetido con el #{Product.where(:name => product.name).first.id}"
        else
          raise "#{product.errors.full_messages}"
        end
      end
    end
  end
end
