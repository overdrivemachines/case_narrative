# Create or update the sample case records used by the case workspace.
# Loaded by db/seeds.rb and available individually as db:seed:cases.
[
  { title: "Morgan v. Northstar Services", case_number: "CV-2026-0148", case_type: "Employment", county: "Johnson County", filed_on: Date.new(2026, 10, 12), status: "Active", description: "My account of changes in responsibilities and the conversations that followed." },
  { title: "Morgan v. Parkside Properties", case_number: "SC-2026-0083", case_type: "Small claims", county: "Johnson County", filed_on: Date.new(2026, 9, 4), status: "In progress", description: "Repair requests, photographs, and communication with the property manager." },
  { title: "Morgan v. Westbrook Insurance", case_number: "CV-2026-0031", case_type: "Insurance", county: "Douglas County", filed_on: Date.new(2026, 6, 18), status: "Closed", description: "The sequence of events and supporting records for my insurance claim." },
  { title: "Morgan v. Summit Renovations", case_number: "SC-2025-0067", case_type: "Contract", county: "Wyandotte County", filed_on: Date.new(2025, 12, 13), status: "Archived", description: "Agreements, payments, and correspondence about the renovation work." }
].each do |attributes|
  case_record = Case.find_or_initialize_by(case_number: attributes[:case_number])
  case_record.update!(attributes)
end

puts "Seeded 4 sample cases."
