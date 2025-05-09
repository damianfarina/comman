module Office
  class DashboardController < ApplicationController
    def index
      @recent_activities = PaperTrail::Version.order(created_at: :desc).limit(10)
      user_ids = @recent_activities.pluck(:whodunnit).compact.uniq
      @version_user_names = User.where(id: user_ids).pluck(:id, :name).to_h
    end
  end
end
