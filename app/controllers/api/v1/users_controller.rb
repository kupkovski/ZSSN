require_relative "../../../serializers/user_serializer"

module Api
  module V1
    class UsersController < ApiController
      def index
        @users = User.all
        render json: @users
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :gender, :latitude, :longitude, :birthdate)
      end
    end
  end
end
