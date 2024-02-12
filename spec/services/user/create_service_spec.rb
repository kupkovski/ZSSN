require 'rails_helper'
require_relative '../../../app/services/user/create_service'

RSpec.describe Services::User::CreateService, type: :service do
  let(:attributes) {
    {
      name: "John Doe",
      gender: "male",
      latitude: 19.98,
      longitude: 29.88,
      birthdate: "1980-01-01"
    }
  }

  subject {
    described_class.new(
      name: attributes[:name],
      gender: attributes[:gender],
      latitude: attributes[:latitude],
      longitude: attributes[:longitude],
      birthdate: attributes[:birthdate],
    )
  }

  describe '#call' do
    context 'with valid attributes' do
      it 'creates a new user and an inventory associated with it' do
        expect do
          subject.call
        end.to change { User.count }.by(1)
        .and change { Inventory.count }.by(1)

        created_user = User.last
        expect(created_user.name).to eq attributes[:name]
        expect(created_user.gender).to eq attributes[:gender]
        expect(created_user.latitude).to eq attributes[:latitude]
        expect(created_user.longitude).to eq attributes[:longitude]
        expect(created_user.birthdate).to eq Date.new(1980, 1, 1)
        expect(created_user.inventory).to_not be_blank
      end
    end

    context 'with invalid attributes' do
      let(:attributes) {
        {
          name: nil,
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        }
      }

      it 'does not create the user nor the inventory' do
        expect do
          subject.call
        end.to_not change { User.count }

        expect do
          subject.call
        end.to_not change { Inventory.count }
        expect(subject.errors[:name]).to eq ["must be filled"]
      end
    end
  end
end
