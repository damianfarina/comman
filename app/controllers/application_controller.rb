class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails, Authentication

  helper_method :current_department

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # FIXME: Enable the feature.
  # allow_browser versions: :modern

  def current_department
    @current_department ||= params[:department].to_sym if params[:department].present?
  end
end
