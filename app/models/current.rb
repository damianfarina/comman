class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :http_method, :request_id, :user_agent, :ip_address, :referrer, :department

  delegate :user, to: :session, allow_nil: true
end
