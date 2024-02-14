# frozen_string_literal: true

module API
  module V1
    # Main controller for the api
    class ApiController < ActionController::Base
      respond_to :json
    end
  end
end
