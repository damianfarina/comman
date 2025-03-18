module Productable
  extend ActiveSupport::Concern

  included do
    has_one :product, as: :productable, touch: true, autosave: true
    default_scope { includes(:product) }

    def name
      raise NotImplementedError
    end
  end
end
