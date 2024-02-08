require 'rails_helper'

RSpec.describe "/api/v1/users/:id/inventory/add_item", type: :request do
  describe "POST /add_item" do
    let(:user) {
      User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    context "when item exists" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:ammo)  { Item.create!(name: "munição", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }

      context "with valid parameters" do
        it 'adds an item to the user inventory' do
          expect do
            post add_item_api_v1_inventory_path(user), params: { item: { name: ammo.name } }, as: :json
            user.inventory.reload
          end.to change { user.inventory.items.map(&:name) }.to include(ammo.name)
        end
      end
    end

    context "when item does not exist" do
      let!(:water) { Item.create!(name: "água", cost: 1) }
      let!(:inventory) { Inventory.create!(user: user, items: [water]) }

      context "with valid parameters" do

        it 'adds an item to the user inventory' do
          expect do
            post add_item_api_v1_inventory_path(user), params: { item: { name:  ::Item::VALID_NAMES.last } }, as: :json
            user.inventory.reload
          end. to change { Item.count }.by(1)
          .and change { user.inventory.items.map(&:name) }.to include( ::Item::VALID_NAMES.last)
        end
      end
    end
  end
end
