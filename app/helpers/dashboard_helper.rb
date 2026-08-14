module DashboardHelper
  def dashboard_display_name
    current_user.name.presence || current_user.email.split("@").first.titleize
  end

  def dashboard_first_name
    dashboard_display_name.split.first
  end

  def dashboard_initials
    dashboard_display_name.split.filter_map { |part| part.first }.first(2).join.upcase
  end
end
