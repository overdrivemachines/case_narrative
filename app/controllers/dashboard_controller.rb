class DashboardController < ApplicationController
  before_action :authenticate_user!

  layout "dashboard"

  # @route GET /dashboard (dashboard)
  def index
  end
end
