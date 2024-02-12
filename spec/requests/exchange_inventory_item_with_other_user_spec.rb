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
      let!(:food) { Item.create!(name: "comida", cost: 1) }
      let!(:ammo)  { Item.create!(name: "munição", cost: 1) }
      let!(:medicine)  { Item.create!(name: "remédio", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water, food]) }
      let!(:friend_inventory) { Inventory.create!(user: friend, items: [ammo, medicine]) }

      context "with valid parameters" do
        it 'adds an item to the user inventory' do
          expect do
            put exchange_item_api_v1_inventory_path(user), params: {
              destination_user: {
                id: friend.id,
                item_names: [ammo.name, medicine.name]
              },
              origin_user: {
                item_names: [water.name, food.name]
              }
            }, as: :json
            user.inventory.reload
            friend.inventory.reload
          end.to change { user.inventory.items.map(&:name) }.from(%w[água comida]).to(%w[munição remédio])
          .and change { friend.inventory.items.map(&:name) }.from(%w[munição remédio]).to(%w[água comida])
        end
      end
    end

    context "when item does not exist on origin user's inventory" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:food) { Item.create!(name: "comida", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: []) }
      let!(:friend_inventory) { Inventory.create!(user: friend, items: [water]) }

      context "with valid parameters" do

        it 'does not add the item to the user inventory' do
          expect do
            put exchange_item_api_v1_inventory_path(user), params: {
              destination_user: {
                id: friend.id,
                item_names: [water.name]
                },
              origin_user: {
                item_names: [food.name]
              }
            }, as: :json

            user.inventory.reload
          end.to_not change { user.inventory.items.map(&:name) }
          expect(response.body).to eq "{\"error\":\"the following items are not on origin user's inventory: comida\"}"
          expect(response.status).to eq 404
        end
      end
    end

    context "when item does not exist on destination user's inventory" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:food) { Item.create!(name: "comida", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }
      let!(:friend_inventory) { Inventory.create!(user: friend) }

      context "with valid parameters" do

        it 'does not add the item to the user inventory' do
          expect do
            put exchange_item_api_v1_inventory_path(user), params: {
              destination_user: {
                id: friend.id,
                item_names: [water.name]
                },
              origin_user: {
                item_names: [water.name]
              }
            }, as: :json

            user.inventory.reload
          end.to_not change { user.inventory.items.map(&:name) }
          expect(response.body).to eq "{\"error\":\"the following items are not on destination user's inventory: água\"}"
          expect(response.status).to eq 404
        end
      end
    end
  end
end
