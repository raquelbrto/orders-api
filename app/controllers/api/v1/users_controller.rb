module Api
  module V1
    class UsersController < ApplicationController
      def index
        @users = Users::ShowAllUseCase.new.execute
        response = UserPresenter.new(@users).show_all

        render json: response[:data], status: response[:status]
      end

      def show
        @user = Users::ShowUseCase.new.execute(params[:id])
        response = UserPresenter.new(@user).show
        render json: response[:data], status: response[:status]
      end
    end
  end
end
