require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users/{id}' do
    get 'Retrieve user' do
      tags 'API::V1::Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'User found' do
        schema type: :object,
        properties: {
          user_id: { type: :integer },
          name: { type: :string }
        }

        let(:user) { create(:user) }
        let(:id) { user.id }

        run_test!
      end

      response '404', 'User not found' do
        let(:id) { 'invalid' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq("User not found")
        end
      end
    end
  end

  path '/api/v1/users/' do
    get 'Retrieve all users' do
      tags 'API::V1::Users'
      produces 'application/json'

      response '200', 'Retrieve all users' do
        schema type: :array,
        items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            created_at: { type: :string, format: 'date-time' },
             updated_at: { type: :string, format: 'date-time' }
          },
          required: [ 'id', 'name', 'created_at', 'updated_at' ]
        }

        let!(:user) { create_list(:user, 3) }

        run_test! do |response|
          users = JSON.parse(response.body)
          expect(users.count).to eq(3)
        end
      end
    end
  end
end
