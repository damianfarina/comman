class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_department

  before_action :set_paper_trail_whodunnit

  def user_for_paper_trail
    Current.user.id if authenticated?
  end

  def info_for_paper_trail
    { department: current_department }
  end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # FIXME: Enable the feature.
  # allow_browser versions: :modern

  def current_department
    @current_department ||= params[:department]
  end
end
