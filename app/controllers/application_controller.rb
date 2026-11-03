class ApplicationController < ActionController::Base
  layout :application_layout

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Returns the saved destination or the personal case list after sign-in.
  # Called by Devise after successful authentication.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || cases_path
  end

  private

  def application_layout
    devise_controller? ? "devise" : "application"
  end
end
