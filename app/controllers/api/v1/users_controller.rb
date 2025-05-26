require_relative "../../../serializers/user_serializer"

module Api
  module V1
    class UsersController < ApiController
      def index
        @users = User.all
        render json: @users
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end

      def create
        @user = User.new(create_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      def update
        @user = User.find(params[:id])

        if @user.update(update_params)
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      def report_infected
        @suspect_user = User.find(report_infected_params[:id])

        @reporter_user = User.find(report_infected_params[:reporter_user_id])
        @infected_user_report = InfectedUserReport.new(suspect: @suspect_user, reporter: @reporter_user)

        if @infected_user_report.save
          render json: @infected_user_report, status: :ok
        else
          render json: { errors: @infected_user_report.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      private

      def create_params
        params.require(:user).permit(:name, :gender, :latitude, :longitude, :birthdate)
      end

      def update_params
        params.require(:user).permit(:latitude, :longitude)
      end

      def report_infected_params
        params.require(:user).permit(:id, :reporter_user_id)
      end
    end
  end
end
