require 'rails_helper'

RSpec.describe "Api::V1::Files", type: :request do
  describe "GET /index" do
    context "when not have file controller setup yet" do
      it "should return true" do
        expect(true).to eq(true)
      end
    end
  end
end
