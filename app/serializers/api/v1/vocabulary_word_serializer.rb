class Api::V1::VocabularyWordSerializer < ActiveModel::Serializer
  attributes :id, :created_at
  has_one :word
end
