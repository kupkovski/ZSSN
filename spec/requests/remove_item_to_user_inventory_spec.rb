require 'rails_helper'

RSpec.describe "/api/v1/users/:id/inventory/remove_item", type: :request do
  describe "DELETE /remove_item_api_v1_inventory" do
    let(:user) {
      User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    context "when item exists" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }

      context "with valid parameters" do
        it 'removes an item from the user inventory' do
          expect do
            delete remove_item_api_v1_inventory_path(user), params: { item: { name: water.name } }, as: :json
            user.inventory.reload
          end.to change { user.inventory.items.map(&:name) }.from(%w[água]).to %w[]
          expect(response.status).to eq 200
          expect(response.body).to eq UserSerializer.new(user).to_json
        end
      end
    end

    context "when item has a valid name but user does not have it" do
      let!(:water) { Item.create!(name: ::Item::VALID_NAMES.first, cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }

      context "with valid parameters" do

        it 'does not remove an item from the user inventory' do
          expect do
            delete remove_item_api_v1_inventory_path(user), params: { item: { name: ::Item::VALID_NAMES.last } }, as: :json
            user.inventory.reload
          end.to_not change { Item.count }
          expect(response.status).to eq 400
          expect(response.body).to eq "{\"error\":\"Item is not on user's inventory\"}"
        end
      end
    end

    context "when item has an invalid name" do
      let!(:water) { Item.create!(name: ::Item::VALID_NAMES.first, cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }

      context "with valid parameters" do

        it 'does not remove an item from the user inventory' do
          expect do
            delete remove_item_api_v1_inventory_path(user), params: { item: { name:  "undefined" } }, as: :json
            user.inventory.reload
          end.to_not change { Item.count }
          expect(response.status).to eq 404
          expect(response.body).to eq "{\"error\":\"Invalid item name\"}"
        end
      end
    end
  end
end
