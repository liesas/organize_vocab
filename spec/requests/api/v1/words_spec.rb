require 'swagger_helper'

RSpec.describe 'Words V1', type: :request do
  let!(:words) { %w[你好 好 三].map { |str| Fabricate(:word, dictionary_form: str) } }

  path '/api/v1/words' do

    get('list Words') do
      tags 'Words'
      produces 'application/json'
      parameter name: :q, in: :query, required: false

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(response.content_type).to match(a_string_including('application/json'))
          data = JSON.parse(response.body)
          expect(data).to be_an_instance_of(Array)
        end
      end

      response(200, 'successful') do
        let(:q) { URI::Parser.new.escape('好') }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to match([a_hash_including('hanzi' => '你好') ,
                                 a_hash_including('hanzi' => '好')])
          expect(data.count).to eq(2)
        end
      end
    end

    post('create Word') do
      tags 'Words'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :word, in: :body, schema: {
        type: :object,
        properties: {
          language: { type: :string },
          dictionary_form: { type: :string }
        },
        required: [:language, :dictionary_form]
      }

      response(201, 'created') do
        let(:word) { { language: 'zh', dictionary_form: '再见'} }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(Word.count).to eq(4)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end

      response(422, 'unprocessable entity') do
        let(:word) { { language: 'zh', dictionary_form: 'invalid'} }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(Word.count).to eq(3)
          expect(response.content_type).to match(a_string_including('application/json'))
          data = JSON.parse(response.body)
          expect(data['dictionary_form']).to match(a_string_including('is not Chinese'))
        end
      end
    end
  end

  path '/api/v1/words/{id}' do

    get('show Word') do
      tags 'Words'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: :id

      response(200, 'successful') do
        let(:id) { words[0].id }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do |response|
          expect(response.content_type).to match(a_string_including('application/json'))
          data = JSON.parse(response.body)
          expect(data).to have_key('hanzi')
          expect(data).to have_key('language')
          expect(data).to_not have_key('dictionary_form')
          expect(data['hanzi']).to eq(words[0].dictionary_form)
        end
      end

      response(404, 'successful') do
        let(:id) { 'non_existent_id' }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
      end
    end
  end
end
