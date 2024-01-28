require 'rails_helper'

RSpec.describe "/api/v1/update_location", type: :request do
  describe "PATCH /update_location" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          latitude: -14.2400732,
          longitude: -53.1805017
        }
      end

      it "updates the users location" do
        user = User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")

        patch update_location_api_v1_user_url(user),
              params: { user: new_attributes }, as: :json
        user.reload
        expect(user.latitude).to eq -14.2400732
        expect(user.longitude).to eq -53.1805017
      end
    end

    context "with invalid parameters" do
      let(:new_attributes) do
        {
          latitude: nil,
          longitude: "joia"
        }
      end

      it "updates the users location" do
        user = User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")

        patch update_location_api_v1_user_url(user),
              params: { user: new_attributes }, as: :json
        user.reload
        expect(user.latitude).to eq 100
        expect(user.longitude).to eq 200
        expect(response.body).to eq 'Latitude: Should not be blank'
        expect(response.status).to eq 422
      end
    end
  end
end
