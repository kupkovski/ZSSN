require_relative "../../../serializers/inventory_serializer"

module Api
  module V1
    class InventoriesController < ApiController
      def show
        @user = User.find(params[:user_id])
        @inventory = @user.inventory
        render json: @inventory
      end
    end
  end
end
