require 'swagger_helper'

RSpec.describe 'api/v1/products', type: :request do
  path '/api/v1/products/{id}' do
    get 'Retrieve product' do   
      tags 'API::V1::Products'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Retrieve product by id' do
        schema type: :object,
          properties: {
            product_id: { type: :integer },
            value: { type: :string }
          }
  
        let(:product) { create(:product_response) }
        let(:id) { product.id } 
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq("Product not found.")
        end
      end
    end
  end

  path '/api/v1/products/' do
    get 'Retrieve products' do   
      tags 'API::V1::Products'
      produces 'application/json'

      response '200', 'Retrieve' do
        schema type: :array,
        items: {
          type: :object,
          properties: {
            product_id: { type: :integer },
            value: { type: :string }
          },
          required: ['product_id', 'value'] 
        }
  
        let!(:product) { create_list(:product_response, 3) }

        run_test! do |response|
          orders = JSON.parse(response.body)
          expect(orders.count).to eq(3)
        end
      end

      response '200', 'Retrieve all products' do
        schema type: :array,
        items: {
          type: :object,
          properties: {
            product_id: { type: :integer },
            value: { type: :string }
          },
          required: ['product_id', 'value'] 
        }
  
        let!(:product) { create_list(:product_response, 3) }

        run_test! do |response|
          orders = JSON.parse(response.body)
          expect(orders.count).to eq(3)
        end
      end
    end
  end
end