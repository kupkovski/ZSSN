require 'rails_helper'

RSpec.describe "/api/v1/users/:id/inventory/exchange_item", type: :request do
  describe "PUT /exchange_item" do
    let(:user) {
      User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    let(:friend) {
      User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    context "when item exists" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:ammo)  { Item.create!(name: "munição", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }
      let!(:friend_inventory) { Inventory.create!(user: friend, items: [ammo]) }

      context "with valid parameters" do
        it 'adds an item to the user inventory' do
          expect do
            put exchange_item_api_v1_inventory_path(user), params: {
              destination_user: {
                id: friend.id,
                item_name: ammo.name
                },
              item: {
                name: water.name
                }
              }, as: :json

            user.inventory.reload
            friend.inventory.reload
          end.to change { user.inventory.items.map(&:name) }.from(%w[água]).to(%w[munição])
          .and change { friend.inventory.items.map(&:name) }.from(%w[munição]).to(%w[água])
        end
      end
    end

    context "when item does not exist on user inventory" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }
      let!(:friend_inventory) { Inventory.create!(user: friend) }

      context "with valid parameters" do

        it 'does not add the item to the user inventory' do
          expect do
            put exchange_item_api_v1_inventory_path(user), params: {
              destination_user: {
                id: friend.id,
                item_name: water.name
                },
              item: {
                name: water.name
                }
              }, as: :json
            user.inventory.reload
          end.to_not change { user.inventory.items.map(&:name) }
          expect(response.status).to eq 404
          expect(response.body).to eq "{\"error\":\"Item is not on firend's inventory\"}"
        end
      end
    end
  end
end
