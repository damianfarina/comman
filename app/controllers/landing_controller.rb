class LandingController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]

  def index
  end
end
