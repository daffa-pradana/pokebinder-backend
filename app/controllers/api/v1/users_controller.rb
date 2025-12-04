module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request!, only: [ :create ]

      def create
        user = User.new(user_params)
        if user.save
          render json: { user: user.as_json(only: [ :id, :name, :email ]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        authorize_user!
        render json: { user: @user.as_json(only: [ :id, :name, :email ]) }
      end

      def update
        authorize_user!
        if @user.update(user_update_params)
          render json: { user: @user.as_json(only: [ :id, :name, :email ]) }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize_user!
        @user.destroy!
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def user_update_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def authorize_user!
        @user = User.find(params[:id])
        render json: { error: "Forbidden" }, status: :forbidden unless @user == current_user
      end
    end
  end
end
