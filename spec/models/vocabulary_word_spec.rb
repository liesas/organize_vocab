require 'rails_helper'

RSpec.describe VocabularyWord, type: :model do
  let!(:subject) { Fabricate(:vocabulary_word) }

  it "is valid with User and Word" do
    user = Fabricate(:user)
    word = Fabricate(:word, language: 'zh', dictionary_form: '新')
    vocabulary_word = Fabricate.build(:vocabulary_word) do
      user { user }
      word { word }
    end

    expect(vocabulary_word).to be_valid
  end

  it "is valid if VocabularyWord with this Word already exists for other User" do
    new_user = Fabricate(:user)
    existent_word = subject.word
    vocabulary_word = Fabricate.build(:vocabulary_word) do
      user { new_user }
      word { existent_word }
    end
    expect(vocabulary_word).to be_valid
  end

  it "is invalid if VocabularyWord with this Word already exists for same User" do
    existent_user = subject.user
    existent_word = subject.word
    vocabulary_word = Fabricate.build(:vocabulary_word) do
      user { existent_user }
      word { existent_word }
    end
    expect(vocabulary_word).to_not be_valid
    expect(vocabulary_word.errors[:word]).to include("has already been taken")
  end

  it "is invalid without User" do
    vocabulary_word = Fabricate.build(:vocabulary_word) do
      user { nil }
      word { Fabricate.build(:word) }
    end
    expect(vocabulary_word).to_not be_valid
    expect(vocabulary_word.errors[:user]).to include("must exist")
  end

  it "is invalid without Word" do
    vocabulary_word = Fabricate.build(:vocabulary_word) do
      user { Fabricate.build(:user) }
      word { nil }
    end
    expect(vocabulary_word).to_not be_valid
    expect(vocabulary_word.errors[:word]).to include("must exist")
  end
end
