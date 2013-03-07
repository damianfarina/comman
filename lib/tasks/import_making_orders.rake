namespace :db do
  desc "Imports making orders"
  task :load_making_orders => :environment do
    raise "\n \033[93mMissing file param (file=/home/jonhny/file.csv)\033[0m" if ENV['file'].nil?
    require 'tasks/import_making_orders.rb'
    ImportMakingOrders.import ENV['file']
  end
end
