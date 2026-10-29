# Clear application data in foreign-key dependency order.
Courthouse.delete_all
User.delete_all
Address.delete_all

users = [
  { name: "AA", email: "a@a.com" },
  { name: "BB", email: "b@b.com" },
  { name: "CC", email: "c@c.com" }
]

users.each do |attributes|
  User.create!(
    **attributes,
    password: "manager",
    password_confirmation: "manager",
    confirmed_at: Time.current
  )
end

courthouses = [
  {
    name: "Johnson County District Court",
    address: { line_1: "150 W. Santa Fe St", city: "Olathe", state: "KS", country_code: "US" },
    jurisdiction: "Kansas 10th Judicial District",
    homepage: "https://courts.jocogov.org/"
  },
  {
    name: "Robert J. Dole U.S. Courthouse",
    address: { line_1: "500 State Ave", city: "Kansas City", state: "KS", country_code: "US" },
    jurisdiction: "U.S. District Court for the District of Kansas",
    homepage: "https://ksd.uscourts.gov/kansascity"
  },
  {
    name: "Frank Carlson Federal Building",
    address: { line_1: "444 S.E. Quincy", city: "Topeka", state: "KS", country_code: "US" },
    jurisdiction: "U.S. District Court for the District of Kansas",
    homepage: "https://ksd.uscourts.gov/topeka"
  },
  {
    name: "Wichita U.S. Federal Court",
    address: { line_1: "401 N. Market", city: "Wichita", state: "KS", country_code: "US" },
    jurisdiction: "U.S. District Court for the District of Kansas",
    homepage: "https://ksd.uscourts.gov/wichita"
  },
  {
    name: "Kansas Judicial Center",
    address: { line_1: "301 SW 10th Ave", city: "Topeka", state: "KS", country_code: "US" },
    jurisdiction: "Kansas Supreme Court and Kansas Court of Appeals",
    homepage: "https://www.kscourts.gov/"
  }
]

courthouses.each do |attributes|
  address = Address.create!(attributes.fetch(:address))
  Courthouse.find_or_initialize_by(name: attributes.fetch(:name)).update!(**attributes.except(:address), address: address)
end
