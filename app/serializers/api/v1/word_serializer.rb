class Api::V1::WordSerializer < ActiveModel::Serializer
  attributes :id, :language, :dictionary_form

  def attributes(*args)
    hash = super
    hash[:hanzi] = hash.delete :dictionary_form if object.chinese?

    hash
  end
end
