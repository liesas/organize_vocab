require 'swagger_helper'

RSpec.describe 'VocabularyWords V1', type: :request do
  let!(:users) { Fabricate.times(2, :user) }
  let!(:access_token) { Fabricate(:access_token, resource_owner_id: users.first.id) }
  let!(:words) { %w[老 一 二].map { |str| Fabricate(:word, dictionary_form: str) } }
  let!(:vocabulary_words) do
    [Fabricate(:vocabulary_word, user: users[0], word: words[0]),
     Fabricate(:vocabulary_word, user: users[0], word: words[1]),
     Fabricate(:vocabulary_word, user: users[1], word: words[2])]
  end

  context 'when unauthorized' do
    path '/api/v1/vocabulary_words' do
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :q, in: :query, required: false

      get('list VocabularyWords') do
        tags 'VocabularyWords'
        response(401, 'unauthorized') do
          run_test!
        end
      end
    end
  end

  context 'when using incorrect token' do
    path '/api/v1/vocabulary_words' do
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :q, in: :query, required: false
      let(:Authorization) { 'incorrect_token' }

      get('list VocabularyWords') do
        tags 'VocabularyWords'
        response(401, 'unauthorized') do
          run_test!
        end
      end
    end
  end

  context 'when authorized' do
    path '/api/v1/vocabulary_words' do
      parameter name: :Authorization, in: :header, type: :string, required: false
      parameter name: :q, in: :query, required: false
      let(:Authorization) { 'Bearer ' + access_token.token }

      get('list VocabularyWords') do
        tags 'VocabularyWords'
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
            expect(data).to match([a_hash_including('word' => a_hash_including('hanzi' => '老')),
                                   a_hash_including('word' => a_hash_including('hanzi' => '一'))])
            expect(data).to_not match([a_hash_including('word' => a_hash_including('hanzi' => '二'))])
          end
        end

        response(200, 'successful') do
          let(:q) { URI::Parser.new.escape('一') }
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
            expect(data).to match([a_hash_including('word' => a_hash_including('hanzi' => '一'))])
            expect(data.count).to eq(1)
          end
        end
      end

      post('create VocabularyWord') do
        tags 'VocabularyWords'
        produces 'application/json'
        consumes 'application/json'
        parameter name: :vocabulary_word, in: :body, schema: {
          type: :object,
          properties: {
            language: { type: :string },
            dictionary_from: { type: :string }
          },
          required: [:language, :dictionary_form]
        }
        new_word = '新'
        existent_for_other_user_word = '二'
        existent_for_this_user_word = '老'

        response(201, 'created') do
          let(:vocabulary_word) { { language: 'zh', dictionary_form: new_word } }
          after do |example|
            example.metadata[:response][:content] = {
              'application/json' => {
                example: JSON.parse(response.body, symbolize_names: true)
              }
            }
          end
          run_test! do |response|
            expect(VocabularyWord.count).to eq(4)
            expect(Word.count).to eq(4)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end

        response(201, 'created') do
          let(:vocabulary_word) { { language: 'zh', dictionary_form: existent_for_other_user_word } }
          run_test! do |response|
            expect(VocabularyWord.count).to eq(4)
            expect(Word.count).to eq(3)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end

        response(422, 'unprocessable entity') do
          let(:vocabulary_word) { { language: 'zh', dictionary_form: existent_for_this_user_word } }
          run_test! do |response|
            expect(VocabularyWord.count).to eq(3)
            expect(Word.count).to eq(3)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end

        response(422, 'unprocessable entity') do
          let(:vocabulary_word) { { language: 'zh', dictionary_form: 'invalid' } }
          after do |example|
            example.metadata[:response][:content] = {
              'application/json' => {
                example: JSON.parse(response.body, symbolize_names: true)
              }
            }
          end
          run_test! do |response|
            expect(VocabularyWord.count).to eq(3)
            expect(Word.count).to eq(3)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end
      end
    end

    path '/api/v1/vocabulary_words/{id}' do
      parameter name: :Authorization, in: :header, type: :string, required: false
      let(:Authorization) { 'Bearer ' + access_token.token }

      get('show VocabularyWord') do
        tags 'VocabularyWords'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string
        response(200, 'successful') do
          let(:id) { vocabulary_words[0].id }

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
            expect(data).to have_key('created_at')
            expect(data['word']).to have_key('language')
            expect(data['word']['hanzi']).to eq('老')
          end
        end
      end

      delete('delete VocabularyWord') do
        tags 'VocabularyWords'
        parameter name: :id, in: :path, type: :string

        response(204, 'no content') do
          let(:id) { vocabulary_words[0].id }
          run_test! do
            VocabularyWord.count(1)
            Word.count(2)
          end
        end
      end
    end
  end
end