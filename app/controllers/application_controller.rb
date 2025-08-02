class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails, Authentication

  helper_method :current_department

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # FIXME: Enable the feature.
  # allow_browser versions: :modern

  def current_department
    @current_department ||= params[:department].to_sym if params[:department].present?
  end

  def redirect_to_back_if_requested
    if params[:back_to].present?
      redirect_to params[:back_to]
    end
  end
end
