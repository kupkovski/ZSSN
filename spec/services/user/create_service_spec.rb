require 'rails_helper'
require_relative '../../../app/services/user/create_service'

RSpec.describe Services::User::CreateService, type: :service do
  let(:valid_attributes) {
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
      name: "John Doe",
      gender: "male",
      latitude: 19.98,
      longitude: 29.88,
      birthdate: "1980-01-01"
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
        expect(created_user.name).to eq valid_attributes[:name]
        expect(created_user.gender).to eq valid_attributes[:gender]
        expect(created_user.latitude).to eq valid_attributes[:latitude]
        expect(created_user.longitude).to eq valid_attributes[:longitude]
        expect(created_user.birthdate).to eq Date.new(1980, 1, 1)
        expect(created_user.inventory).to_not be_blank
      end
    end
  end
end
