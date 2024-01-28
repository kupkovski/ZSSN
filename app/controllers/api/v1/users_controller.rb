require_relative '../../../services/'
require_relative '../../../serializers/user_serializer'

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[ show update destroy ]

      # GET /users
      def index
        @users = User.all

        render json: @users
      end

      # GET /users/1
      def show
        render json: UserSerializer.new(@user).to_json
      end

      # POST /users
      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1/update_location
      def update_location
        @user = User.find(params[:id])
        location_params = update_location_params
        service = ::Services::User::UpdateLocationService.new(
          user: @user,
          latitude: location_params[:latitude],
          longitude: location_params[:longitude]
        )

        if service.call
          render json: :ok
        else
          render json: service.error_messages, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1/report_infected
      def report_infected
        @user = User.find(params[:id])
        report_params = report_infected_params
        @reporter_user = User.find(report_params[:reporter_user_id])
        service = ::Services::User::ReportInfectedService.new(suspect: @user, reporter: @reporter_user)

        if response = service.call
          render json: response
        else
          render json: service.error_messages, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def user_params
          params.require(:user).permit(:name, :gender, :latitude, :longitude, :birthdate)
        end

        def update_location_params
          params.require(:user).permit(:latitude, :longitude)
        end

        def report_infected_params
          params.require(:user).permit(:reporter_user_id)
        end
    end
  end
end
