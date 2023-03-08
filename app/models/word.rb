class Word < ApplicationRecord
  LANGUAGES = %w[zh].freeze

  validates :language, presence: true, inclusion: { in: LANGUAGES }
  validates :dictionary_form, presence: true
  validate :dictionary_form_cannot_be_duplicate_for_same_language
  validates :dictionary_form, format: { with: /\p{Han}/ }, if: -> { chinese? }

  def chinese?
    language == 'zh'
  end

  private

    def dictionary_form_cannot_be_duplicate_for_same_language
      if Word.find_by(language: language, dictionary_form: dictionary_form)
        errors.add(:dictionary_form, "has already been taken")
      end
    end
end
