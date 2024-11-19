module Api
  module V1
    class TransactionsController < ApplicationController
      def index
        @transactions = Transactions::ShowAllUseCase.new.execute
        response = TransactionPresenter.new(@transactions).show_all

        render json: response[:data], status: response[:status]
      end

      def process_file
        file = params[:file]
        if file.size > 0 && file && file.content_type == "text/plain"
          file_content = params[:file].read
          @transactions = Transactions::ProcessFileUseCase.new.execute(file_content)
          response = TransactionPresenter.new(@transactions).as_json

          render json: response, status: :created
        else
          render json: { error: "Empty data file" }, status: 404
        end
      end

      def show
        @transaction = Transactions::ShowUseCase.new.execute(params[:id])
        response = TransactionPresenter.new(@transaction).show
        render json: response[:data], status: response[:status]
      end

      def destroy
        @transaction.destroy!
      end
    end
  end
end
