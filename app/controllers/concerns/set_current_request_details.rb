module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
     before_action do
      Current.http_method = request.method
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
      Current.referrer = request.referrer
      Current.department = current_department
     end
  end
end
