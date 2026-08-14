# Clear application data in foreign-key dependency order.
Courthouse.delete_all
User.delete_all

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
    address: "150 W. Santa Fe St",
    city: "Olathe",
    state: "KS",
    jurisdiction: "Kansas 10th Judicial District",
    homepage: "https://courts.jocogov.org/"
  },
  {
    name: "Robert J. Dole U.S. Courthouse",
    address: "500 State Ave",
    city: "Kansas City",
    state: "KS",
    jurisdiction: "U.S. District Court for the District of Kansas",
    homepage: "https://ksd.uscourts.gov/kansascity"
  },
  {
    name: "Frank Carlson Federal Building",
    address: "444 S.E. Quincy",
    city: "Topeka",
    state: "KS",
    jurisdiction: "U.S. District Court for the District of Kansas",
    homepage: "https://ksd.uscourts.gov/topeka"
  },
  {
    name: "Wichita U.S. Federal Court",
    address: "401 N. Market",
    city: "Wichita",
    state: "KS",
    jurisdiction: "U.S. District Court for the District of Kansas",
    homepage: "https://ksd.uscourts.gov/wichita"
  },
  {
    name: "Kansas Judicial Center",
    address: "301 SW 10th Ave",
    city: "Topeka",
    state: "KS",
    jurisdiction: "Kansas Supreme Court and Kansas Court of Appeals",
    homepage: "https://www.kscourts.gov/"
  }
]

courthouses.each do |attributes|
  Courthouse.find_or_initialize_by(name: attributes.fetch(:name)).update!(attributes)
end
