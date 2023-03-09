class User < ApplicationRecord
  has_many :vocabulary_words
  has_many :words, through: :vocabulary_words

  validates :name, uniqueness: { case_sensitive: false }, presence: true, format: { with: /\A[\w-]{3,20}\z/ }
end
