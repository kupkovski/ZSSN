module Api
  module V1
    class InventoriesController < ApplicationController
      def add_item
        @user = User.find(params[:id])

        render json: @user
      end

    end
  end
end
