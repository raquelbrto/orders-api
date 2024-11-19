module Api
  module V1
    class ProductsController < ApplicationController

      def index
        @products = Products::ShowAllUseCase.new.execute
        response = ProductPresenter.new(@products).show_all

        render json: response[:data], status: response[:status]
      end

      def show
        @product = Products::ShowUseCase.new.execute(params[:id])
        response = ProductPresenter.new(@product).show

        render json: response[:data], status: response[:status]
      end
    end
  end
end
