class Api::V1::WordsController < ApplicationController
  before_action :set_word, only: [:show]

  # GET /api/v1/words
  def index
    @words = Word.all

    render json: @words
  end

  # GET /api/v1/words/1
  def show
    render json: @word
  end

  # POST /api/v1/words
  def create
    @word = Word.new(word_params)

    if @word.save
      render json: @word, status: :created, location: api_v1_word_url(@word)
    else
      render json: @word.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def word_params
      params.require(:word).permit(:dictionary_form, :language)
    end
end
