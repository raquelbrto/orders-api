require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'api/v1/transactions', type: :request do
  path '/api/v1/transactions/process-file' do
    post 'Processa um arquivo de transações' do
      tags 'API::V1::Transactions'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :file, in: :formData, type: :file, description: 'Arquivo txt contendo pedidos'

      response '201', 'Process file sucess' do
        schema type: :object,
        properties: {
          results: {
            type: :array,
              items: {
                type: :object,
                properties: {
                  user_id: { type: :integer },
                  name: { type: :string },
                  orders: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        order_id: { type: :integer },
                        total: { type: :string },
                        products: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              product_id: { type: :integer },
                              value: { type: :string }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

        let(:file) { fixture_file_upload('/data_test.txt', 'text/plain') }
        run_test!
      end

      response '404', 'Empty parameter file' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Empty data file' }
               }

        let(:file) { nil }

        run_test!
      end
    end
  end
end
