require 'swagger_helper'

RSpec.describe 'Users V1', type: :request do

  let!(:application) { Fabricate(:application) }

  path '/api/v1/users' do

    post('register') do
      tags 'OAuth User'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          client_id: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: [:client_id, :email, :password]
      }

      response(201, 'created') do
        let(:user) { { client_id: application.uid, email: 'valid@email.com', password: '123456'} }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(User.count).to eq(1)
          data = JSON.parse(response.body)
          expect(data).to have_key('access_token')
          expect(data).to have_key('token_type')
          expect(data).to have_key('expires_in')
          expect(data).to have_key('refresh_token')
          expect(data).to have_key('created_at')
        end
      end


      response(422, 'unprocessable entity') do
        let(:user) { { client_id: application.uid, email: 'invalid@email', password: '123456'} }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do
          expect(User.count).to eq(0)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end

      response(401, 'unauthorized') do
        let(:user) { { client_id: 'invalid_client_id', email: 'valid@email.com', password: '123456'} }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do
          expect(User.count).to eq(0)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end
  end
end
