class CasesController < ApplicationController
  before_action :authenticate_user!

  # Temporary presentation data keeps these screens independent of case models.
  # Replace with owner-scoped records when case persistence is implemented.
  SAMPLE_CASES = [
    { id: "workplace-concerns", title: "Morgan v. Northstar Services", number: "CV-2026-0148", type: "Employment", county: "Johnson County", filed_on: "October 12, 2026", status: "Active", description: "My account of changes in responsibilities and the conversations that followed." },
    { id: "apartment-repairs", title: "Morgan v. Parkside Properties", number: "SC-2026-0083", type: "Small claims", county: "Johnson County", filed_on: "September 4, 2026", status: "In progress", description: "Repair requests, photographs, and communication with the property manager." },
    { id: "insurance-claim", title: "Morgan v. Westbrook Insurance", number: "CV-2026-0031", type: "Insurance", county: "Douglas County", filed_on: "June 18, 2026", status: "Closed", description: "The sequence of events and supporting records for my insurance claim." },
    { id: "contract-dispute", title: "Morgan v. Summit Renovations", number: "SC-2025-0067", type: "Contract", county: "Wyandotte County", filed_on: "December 13, 2025", status: "Archived", description: "Agreements, payments, and correspondence about the renovation work." }
  ].map(&:freeze).freeze

  # Displays sample cases, optionally narrowed by the submitted search text.
  # Called by GET /cases from the navigation and case-search form.
  def index
    @query = params[:q].to_s.strip.first(200)
    @cases = SAMPLE_CASES.select do |case_details|
      case_details.values.join(" ").downcase.include?(@query.downcase)
    end
  end

  # Opens a sample case without querying the legacy Case model.
  # Called by GET /cases/:id from a case row on cases/index.
  def show
    @case_details = SAMPLE_CASES.find { |case_details| case_details[:id] == params[:id] }
    raise ActionController::RoutingError, "Not Found" unless @case_details
  end
end
