# Load every seed file in a predictable order for the standard db:seed task.
# Files can also be run individually with bin/rails db:seed:<name>.
Dir[Rails.root.join("db/seeds/*.rb")].sort.each do |file|
  load file
end
