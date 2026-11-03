namespace :db do
  namespace :seed do
    Dir[Rails.root.join("db/seeds/*.rb")].sort.each do |file|
      seed_name = File.basename(file, ".rb")

      desc "Run db/seeds/#{seed_name}.rb"
      task seed_name => :environment do
        puts "Running db/seeds/#{seed_name}.rb"
        load file
      end
    end
  end
end
