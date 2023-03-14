require "rails_helper"

RSpec.describe Api::V1::VocabularyWordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/vocabulary_words").to route_to("api/v1/vocabulary_words#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/vocabulary_words/1").to route_to("api/v1/vocabulary_words#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/vocabulary_words").to route_to("api/v1/vocabulary_words#create")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/vocabulary_words/1").to route_to("api/v1/vocabulary_words#destroy", id: "1")
    end
  end
end
