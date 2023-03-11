require "rails_helper"

RSpec.describe Api::V1::WordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/words").to route_to("api/v1/words#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/words/1").to route_to("api/v1/words#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/words").to route_to("api/v1/words#create")
    end
  end
end
