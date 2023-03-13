class User < ApplicationRecord
  has_many :vocabulary_words
  has_many :words, through: :vocabulary_words

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, email: { mode: :strict }
end
