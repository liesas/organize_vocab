module Filterable
  extend ActiveSupport::Concern

  included do
    def filtered_words
      @words_to_filter.where('words.dictionary_form LIKE ?', "%#{@q}%")
    end
  end
end
