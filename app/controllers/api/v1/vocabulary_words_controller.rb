class Api::V1::VocabularyWordsController < ApplicationController
  include Filterable

  wrap_parameters Word

  before_action :set_vocabulary_word, only: %i[ show destroy ]

  # GET /api/v1/vocabulary_words
  def index
    @vocabulary_words = VocabularyWord.where('user_id = ?', current_user.id)

    if (@q = params[:q])
      @words_to_filter = @vocabulary_words.left_joins(:word)
      render json: filtered_words
    else
      render json: @vocabulary_words
    end
  end

  # GET /api/v1/vocabulary_words/1
  def show
    render json: @vocabulary_word
  end

  # POST /api/v1/vocabulary_words
  def create
    user = User.find(current_user.id)
    word = Word.find_or_create_by(language: word_params[:language], dictionary_form: word_params[:dictionary_form])

    @vocabulary_word = VocabularyWord.new(user_id: user.id, word_id: word.id)

    if word.new_record? and word.invalid?
      render json: word.errors, status: :unprocessable_entity
    elsif @vocabulary_word.save
      render json: @vocabulary_word, status: :created, location: api_v1_vocabulary_word_url(user, @vocabulary_word)
    else
      render json: @vocabulary_word.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/vocabulary_words/1
  def destroy
    @vocabulary_word.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vocabulary_word
      @vocabulary_word = VocabularyWord.find_by(user_id: current_user.id, id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def word_params
      params.require(:word).permit(:language, :dictionary_form)
    end
end
