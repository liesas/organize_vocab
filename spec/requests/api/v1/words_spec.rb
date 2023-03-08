require 'swagger_helper'

RSpec.describe 'Words V1', type: :request do

  let!(:subject) { Fabricate(:word, id: 123, language: 'zh', dictionary_form: '你好') }

  path '/api/v1/words' do

    get('list Words') do
      tags 'Words'
      produces 'application/json'

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
          expect(Word.count).to eq(2)
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
          expect(Word.count).to eq(1)
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
      parameter name: 'id', in: :path, type: :string, description: 'id'

      response(200, 'successful') do
        let(:id) { subject.id }
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
          expect(data).to be_an_instance_of(Hash)
          expect(data).to have_key('hanzi')
          expect(data).to have_key('language')
          expect(data).to_not have_key('dictionary_form')
          expect(data['hanzi']).to eq(subject.dictionary_form)
        end
      end
    end
  end
end
