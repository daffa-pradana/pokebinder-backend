module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request!, only: [ :create ]
      before_action :authorize_user!, only: [ :show, :update, :destroy ]

      def create
        user = User.new(user_params)
        if user.save
          render json: { user: user.as_json(only: [ :id, :name, :email ]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: { user: @user.as_json(only: [ :id, :name, :email ]) }
      end

      def update
        if @user.update(user_update_params)
          render json: { user: @user.as_json(only: [ :id, :name, :email ]) }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
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
        unless @user == current_user
          render json: { error: "Forbidden" }, status: :forbidden
        end
      end
    end
  end
end
