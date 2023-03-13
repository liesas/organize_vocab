require 'swagger_helper'

RSpec.describe 'Users V1', type: :request do

  pending

  # let!(:subject) { Fabricate(:user, id: 123, name: 'valid_name') }
  #
  # path '/api/v1/users' do
  #
  #   get('list Users') do
  #     tags 'Users'
  #     produces 'application/json'
  #
  #     response(200, 'successful') do
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test! do |response|
  #         expect(response.content_type).to match(a_string_including('application/json'))
  #         data = JSON.parse(response.body)
  #         expect(data).to be_an_instance_of(Array)
  #       end
  #     end
  #   end
  #
  #   post('create User') do
  #     tags 'Users'
  #     produces 'application/json'
  #     consumes 'application/json'
  #     parameter name: :user, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         name: { type: :string }
  #       },
  #       required: [:name]
  #     }
  #
  #     response(201, 'created') do
  #       let(:user) { { name: 'new_valid_name'} }
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test! do |response|
  #         expect(User.count).to eq(2)
  #         expect(response.content_type).to match(a_string_including('application/json'))
  #       end
  #     end
  #
  #     response(422, 'unprocessable entity') do
  #       let(:user) { { name: 'invalid_name!'} }
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test! do
  #         expect(User.count).to eq(1)
  #         expect(response.content_type).to match(a_string_including('application/json'))
  #       end
  #     end
  #   end
  # end
  #
  # path '/api/v1/users/{id}' do
  #
  #   get('show User') do
  #     tags 'Users'
  #     produces 'application/json'
  #     parameter name: 'id', in: :path, type: :string, description: 'id'
  #
  #     response(200, 'successful') do
  #       let(:id) { subject.id }
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test! do |response|
  #         expect(response.content_type).to match(a_string_including('application/json'))
  #         data = JSON.parse(response.body)
  #         expect(data).to be_an_instance_of(Hash)
  #         expect(data['name']).to eq(subject.name)
  #       end
  #     end
  #   end
  #
  #   patch('update User') do
  #     tags 'Users'
  #     produces 'application/json'
  #     consumes 'application/json'
  #     parameter name: 'id', in: :path, type: :string, description: 'id'
  #     let(:id) { subject.id }
  #     parameter name: :user, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         name: { type: :string }
  #       },
  #       required: [:name]
  #     }
  #
  #     response(200, 'successful') do
  #       let(:user) { { name: 'new_valid_name'} }
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test! do |response|
  #         expect(User.count).to eq(1)
  #         expect(response.content_type).to match(a_string_including('application/json'))
  #         data = JSON.parse(response.body)
  #         expect(data['name']).to eq('new_valid_name')
  #       end
  #     end
  #
  #     response(422, 'unprocessable entity') do
  #       let(:user) { { name: 'invalid_name!'} }
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test! do
  #         expect(response.content_type).to match(a_string_including('application/json'))
  #       end
  #     end
  #   end
  #
  #   delete('delete User') do
  #     tags 'Users'
  #     parameter name: 'id', in: :path, type: :string, description: 'id'
  #
  #     response(204, 'no content') do
  #       let(:id) { subject.id }
  #       run_test! do
  #         expect(User.count).to eq(0)
  #       end
  #     end
  #   end
  # end
end
