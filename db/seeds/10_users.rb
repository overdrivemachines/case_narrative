# Create the default development users used by the application.
# This file is loaded by db/seeds.rb and can be run independently with db:seed:users.
[
  { email: "a@a.com", name: "AA", role: :admin },
  { email: "get.dipen@gmail.com", name: "Dipen Chauhan", role: :admin },
  { email: "b@b.com", name: "BB", role: :standard }
].each do |attributes|
  user = User.new(attributes.merge(password: "manager", password_confirmation: "manager"))
  user.skip_confirmation!
  user.save!
end
