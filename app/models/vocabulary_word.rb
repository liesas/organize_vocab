class VocabularyWord < ApplicationRecord
  belongs_to :user
  belongs_to :word

  validates_uniqueness_of :word, scope: :user
end
