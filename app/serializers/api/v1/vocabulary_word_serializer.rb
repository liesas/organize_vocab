class Api::V1::VocabularyWordSerializer < ActiveModel::Serializer
  attributes :id
  has_one :user
  has_one :word
end
