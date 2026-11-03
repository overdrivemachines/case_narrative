class CasesController < ApplicationController
  before_action :authenticate_user!

  # Displays saved cases, optionally narrowed by the submitted search text.
  # Called by GET /cases from the navigation and case-search form.
  # @route GET /cases (cases)
  def index
    @query = params[:q].to_s.strip.first(200)
    @cases = Case.all

    if @query.present?
      query = "%#{Case.sanitize_sql_like(@query)}%"
      @cases = @cases.where(
        "title ILIKE :query OR case_number ILIKE :query OR case_type ILIKE :query OR county ILIKE :query",
        query: query
      )
    end

    @cases = @cases.order(filed_on: :desc, created_at: :asc)
  end

  # Opens a saved case by its UUID.
  # Called by GET /cases/:id from a case row on cases/index.
  # @route GET /cases/:id (case)
  def show
    @case_record = Case.find(params[:id])
  end
end
