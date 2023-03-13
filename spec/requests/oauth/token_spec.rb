require 'swagger_helper'

RSpec.describe 'OAuth Token', type: :request do
  let!(:application) { Fabricate(:application) }
  let!(:user) { Fabricate(:user) }
  let!(:token) { Fabricate(:access_token, application: application, resource_owner_id: user.id) }

  path '/oauth/token' do

    post('login') do
      produces 'application/json'
      consumes 'application/json'
      parameter name: :login, in: :body, schema: {
        type: :object,
        properties: {
          grant_type: { type: :string },
          email: { type: :string },
          password: { type: :string },
          client_id: { type: :string },
          client_secret: { type: :string }
        },
        required: [:client_id, :email, :password, :client_id, :client_secret]
      }

      response(200, 'successful') do
        let(:login) { { grant_type: 'password', email: user.email, password: user.password,
                        client_id: application.uid, client_secret: application.secret } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('access_token')
          expect(data).to have_key('token_type')
          expect(data).to have_key('expires_in')
          expect(data).to have_key('refresh_token')
          expect(data).to have_key('created_at')
        end
      end
    end

    post('refresh') do
      produces 'application/json'
      consumes 'application/json'
      parameter name: :refresh, in: :body, schema: {
        type: :object,
        properties: {
          grant_type: { type: :string },
          refresh_token: { type: :string },
          client_id: { type: :string },
          client_secret: { type: :string }
        },
        required: [:grant_type, :refresh_token, :client_id, :client_secret]
      }

      response(200, 'successful') do
        let(:refresh) { { grant_type: 'refresh_token', refresh_token: token.refresh_token, client_id: application.uid, client_secret: application.secret } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('access_token')
          expect(data).to have_key('token_type')
          expect(data).to have_key('expires_in')
          expect(data).to have_key('refresh_token')
          expect(data).to have_key('created_at')
        end
      end
    end
  end

  path '/oauth/revoke' do

    post('logout') do
      produces 'application/json'
      consumes 'application/json'
      parameter name: :revoke, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string },
          client_id: { type: :string },
          client_secret: { type: :string }
        },
        required: [:token, :client_id, :client_secret]
      }

      response(200, 'successful') do
        let(:revoke) { { token: token.token, client_id: application.uid, client_secret: application.secret } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
