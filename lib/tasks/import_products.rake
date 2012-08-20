namespace :db do
  desc "Imports products"
  task :load_products => :environment do
    raise "\n \033[93mMissing file param (file=/home/jonhny/file.csv)\033[0m" if ENV['file'].nil?
    require 'tasks/import_products.rb'
    ImportProducts.import ENV['file']
  end
end
