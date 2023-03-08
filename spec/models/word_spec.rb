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

  context 'when Chinese' do
    it "is valid if dictionary_form is made up of simplified or traditional Chinese characters" do
      word = Fabricate.build(:word, language: "zh", dictionary_form: "电脑")
      expect(word).to be_valid

      word = Fabricate.build(:word, language: "zh", dictionary_form: "謝謝")
      expect(word).to be_valid
    end

    it "is not valid if dictionary_form includes non-CJK characters" do
      word = Fabricate.build(:word, language: "zh", dictionary_form: "abc")
      expect(word).to_not be_valid
      expect(word.errors[:dictionary_form]).to include("is not Chinese")
    end

    it "is not valid if dictionary_form includes non-Chinese CJK characters" do
      word = Fabricate.build(:word, language: "zh", dictionary_form: "ㄅㄆㄇㄈ") #bopomofo
      expect(word).to_not be_valid
      expect(word.errors[:dictionary_form]).to include("is not Chinese")

      word = Fabricate.build(:word, language: "zh", dictionary_form: "한글") #hangul
      expect(word).to_not be_valid
      expect(word.errors[:dictionary_form]).to include("is not Chinese")

      word = Fabricate.build(:word, language: "zh", dictionary_form: "ひらがな") #hiragana
      expect(word).to_not be_valid
      expect(word.errors[:dictionary_form]).to include("is not Chinese")

      word = Fabricate.build(:word, language: "zh", dictionary_form: "カタカナ") #katakana
      expect(word).to_not be_valid
      expect(word.errors[:dictionary_form]).to include("is not Chinese")
    end
  end

  describe "#chinese?" do
    it "returns true if language is 'zh'" do
      word = Fabricate.build(:word, language: "zh", dictionary_form: "谢谢")
      expect(word.chinese?).to be_truthy
    end

    it "returns false if language is not 'zh'" do
      word = Fabricate.build(:word, language: "en", dictionary_form: "abc")
      expect(word.chinese?).to be_falsey
    end
  end
end
