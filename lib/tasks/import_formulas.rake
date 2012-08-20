namespace :db do
  desc "Imports formulas"
  task :load_formulas => :environment do
    raise "\n \033[93mMissing file param (file=/home/jonhny/file.csv)\033[0m" if ENV['file'].nil?
    require 'tasks/import_formulas.rb'
    ImportFormulas.import ENV['file']
  end
end
