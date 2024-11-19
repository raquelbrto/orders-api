module Api
  module V1
    class OrdersController < ApplicationController
      def index
        @orders = Orders::ShowAllUseCase.new.execute
        response = OrderPresenter.new(@orders).show_all

        render json: response[:data], status: response[:status]
      end

      def show
        @order = Orders::ShowUseCase.new.execute(params[:id])
        response = OrderPresenter.new(@order).show
        render json: response[:data], status: response[:status]
      end

      def search
        if params[:start_date].present? && params[:end_date].present?
          begin
            start_date = Date.parse(params[:start_date])
            end_date = Date.parse(params[:end_date])

            if start_date > end_date
              render json: { message: "Start date cannot be later than end date." }, status: 400
            else
              @orders = Orders::SearchUseCase.new.execute(params[:start_date], params[:end_date])
              response = OrderPresenter.new(@orders).show_all

              render json: response[:data], status: response[:status]
            end
          rescue ArgumentError
            render json: { message: "Invalid date format. Use yyyy-mm-dd valid." }, status: 400
          end
        else
          render json: { message: "Empty parameters start date and end date." }, status: 400
        end
      end
    end
  end
end
