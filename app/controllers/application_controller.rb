class ApplicationController < ActionController::Base
  layout :application_layout

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  private

  def application_layout
    devise_controller? ? "devise" : "application"
  end
end
