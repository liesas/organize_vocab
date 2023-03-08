class Api::V1::WordSerializer < ActiveModel::Serializer
  attributes :id, :language, :dictionary_form
end
