module ApplicationHelper
  # Return to the previous same-origin page without exposing an external
  # referrer as a navigation target. Direct visits fall back to the homepage.
  def safe_back_path
    return root_path if request.referer.blank? || request.referer == request.original_url

    referrer = URI.parse(request.referer)
    return root_path unless referrer.host == request.host && referrer.port == request.port

    request.referer
  rescue URI::InvalidURIError
    root_path
  end
end
