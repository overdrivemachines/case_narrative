class ApplicationController < ActionController::Base
  layout :application_layout

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def application_layout
    devise_controller? ? "devise" : "application"
  end
end
