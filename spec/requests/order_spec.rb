require 'swagger_helper'

RSpec.describe 'api/v1/orders', type: :request do
  path '/api/v1/orders/{id}' do
    get 'Retrieve order' do
      tags 'API::V1::Orders'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      
      let(:order) { create(:order) }
      response '200', 'order found' do
        let(:id) { order.id }

        before do
          allow(Order).to receive(:find).with(id.to_s).and_return(order)
        end

        run_test!
      end

      response '200', 'Retrieve order by id' do
        schema type: :object,
        properties: {
          order_id: { type: :integer },
          date: { type: :string, format: 'date' },
          total: { type: :string },
          user: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              name: { type: :string }
            }
          },
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
        },
        required: ['order_id', 'date', 'total', 'user', 'products']

        let(:order) { create(:order) }
        let(:id) { order.id } 
        run_test!
      end      
    end
  end

  path '/api/v1/orders/' do
    get 'Retrieves all orders' do
      tags 'API::V1::Orders'
      produces 'application/json'
      
      response '200', 'Orders found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              order_id: { type: :integer },
              date: { type: :string, format: 'date' },
              total: { type: :string, format: 'float' },
              user: {
                type: :object,
                properties: {
                  user_id: { type: :integer },
                  name: { type: :string }
                },
                required: ['user_id', 'name']
              },
              products: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    product_id: { type: :integer },
                    value: { type: :string, format: 'float' }
                  },
                  required: ['product_id', 'value']
                }
              }
            },
            required: ['order_id', 'date', 'total', 'user', 'products']
          }
        let!(:orders) { create_list(:order, 3) }

        run_test! do |response|
          orders = JSON.parse(response.body)
          expect(orders.count).to eq(3)
        end
      end
    end
  end

  path '/api/v1/orders/search' do
    get 'Retrieves orders within a date range' do
      tags 'API::V1::Orders'
      produces 'application/json'
    
      parameter name: :start_date, in: :query, type: :string, description: 'Start date (YYYY-MM-DD)', example: '2021-02-20'
      parameter name: :end_date, in: :query, type: :string, description: 'End date (YYYY-MM-DD)', example: '2024-11-18'
    
      response '200', 'Orders found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              order_id: { type: :integer },
              date: { type: :string, format: 'date' },
              total: { type: :string, format: 'float' },
              user: {
                type: :object,
                properties: {
                  user_id: { type: :integer },
                  name: { type: :string }
                },
                required: ['user_id', 'name']
              },
              products: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    product_id: { type: :integer },
                    value: { type: :string, format: 'float' }
                  },
                  required: ['product_id', 'value']
                }
              }
            },
            required: ['order_id', 'date', 'total', 'user', 'products']
         }
        let!(:orders) { create_list(:order, 3) }
        let(:start_date) { '2021-02-20' }
        let(:end_date) { '2024-11-18' }
          
        run_test! do |response|
          orders = JSON.parse(response.body)
          expect(orders.count).to eq(3)
        end
      end

      response '400', 'Empty parameters start date and end date' do
        let(:start_date) { "" }
        let(:end_date) { "" }
        
        run_test! do |response|
          body = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(body['message']).to eq("Empty parameters start date and end date.")
        end
      end

      response '400', 'Empty parameters start date and end date' do
        let(:start_date) { "" }
        let(:end_date) { "" }
        
        run_test! do |response|
          body = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(body['message']).to eq("Empty parameters start date and end date.")
        end
      end

      response '400', 'Start date cannot be later than end date' do
        let(:start_date) { '2024-11-18' }
        let(:end_date) { '2021-02-20' }
        
        run_test! do |response|
          body = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(body['message']).to eq("Start date cannot be later than end date.")
        end
      end

      response '400', 'Invalid date format. Use yyyy-mm-dd valid.' do
        let(:start_date) { '2024-02-30' }
        let(:end_date) { '2024-11-20' }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(response.status).to eq(400)
          expect(body['message']).to eq("Invalid date format. Use yyyy-mm-dd valid.")
        end
      end
    end
  end
end