require 'tradsim'

class Word < ApplicationRecord
  LANGUAGES = %w[zh].freeze

  before_validation :simplify_chinese_dictionary_form, if: -> { chinese? }

  validates :language, presence: true, inclusion: { in: LANGUAGES }
  validates :dictionary_form, presence: true
  validate :dictionary_form_cannot_be_duplicate_for_same_language
  validates :dictionary_form, format: { with: /\p{Han}/, message: "is not Chinese" }, if: -> { chinese? }

  def chinese?
    language == 'zh'
  end

  private

    def dictionary_form_cannot_be_duplicate_for_same_language
      if Word.find_by(language: language, dictionary_form: dictionary_form)
        errors.add(:dictionary_form, "has already been taken")
      end
    end

    def simplify_chinese_dictionary_form
      self.dictionary_form = Tradsim::to_sim(dictionary_form) if chinese? && dictionary_form.present?
    end
end
