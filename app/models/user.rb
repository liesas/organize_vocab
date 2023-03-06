class User < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, presence: true, format: { with: /\A[\w-]{3,20}\z/ }
end
