class Api::V1::VocabularyWordsController < ApplicationController
  before_action :set_vocabulary_word, only: %i[ show destroy ]

  # GET /api/v1/users/1/vocabulary_words
  def index
    @vocabulary_words = VocabularyWord.all

    render json: @vocabulary_words
  end

  # GET /api/v1/users/1/vocabulary_words/1
  def show
    render json: @vocabulary_word
  end

  # POST /api/v1/users/1/vocabulary_words
  def create
    @vocabulary_word = VocabularyWord.new(vocabulary_word_params)

    if @vocabulary_word.save
      render json: @vocabulary_word, status: :created, location: @vocabulary_word
    else
      render json: @vocabulary_word.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1/vocabulary_words/1
  def destroy
    @vocabulary_word.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vocabulary_word
      @vocabulary_word = VocabularyWord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vocabulary_word_params
      params.require(:vocabulary_word).permit(:user_id, :word_id)
    end
end
