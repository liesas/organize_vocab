class Word < ApplicationRecord
  validates :language, presence: true
  validates :dictionary_form, presence: true
  validate :dictionary_form_cannot_be_duplicate_for_same_language

  private

    def dictionary_form_cannot_be_duplicate_for_same_language
      if Word.find_by(language: language, dictionary_form: dictionary_form)
        errors.add(:dictionary_form, "has already been taken")
      end
    end
end
