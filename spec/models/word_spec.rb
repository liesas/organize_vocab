require 'rails_helper'

RSpec.describe Word, type: :model do
  it "is valid with valid attributes" do
    word = Fabricate.build(:word, language: "zh", dictionary_form: "谢谢")
    expect(word).to be_valid
  end

  it "is not valid without a language" do
    word = Fabricate.build(:word, language: nil, dictionary_form: "谢谢")
    expect(word).to_not be_valid
    expect(word.errors[:language]).to include("can't be blank")
  end

  it "is not valid without a dictionary_form" do
    word = Fabricate.build(:word, language: "zh", dictionary_form: nil)
    expect(word).to_not be_valid
    expect(word.errors[:dictionary_form]).to include("can't be blank")
  end

  it "is not valid with duplicate dictionary_form in same language" do
    Fabricate(:word, language: "zh", dictionary_form: "谢谢")

    word = Fabricate.build(:word, language: "zh", dictionary_form: "谢谢")
    expect(word).to_not be_valid
    expect(word.errors[:dictionary_form]).to include("has already been taken")
  end

  it "is valid with duplicate dictionary_form in other language" do
    Fabricate(:word, language: "zh", dictionary_form: "你好")

    word = Fabricate.build(:word, language: "en", dictionary_form: "你好")
    expect(word.errors[:dictionary_form]).to_not include("has already been taken")
  end
end
