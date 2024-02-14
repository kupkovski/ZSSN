# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../app/services/user/create_service'

RSpec.describe Services::User::CreateService, type: :service do
  subject do
    described_class.new(
      name: attributes[:name],
      gender: attributes[:gender],
      latitude: attributes[:latitude],
      longitude: attributes[:longitude],
      birthdate: attributes[:birthdate]
    )
  end

  let(:attributes) do
    {
      name: 'John Doe',
      gender: 'male',
      latitude: 19.98,
      longitude: 29.88,
      birthdate: '1980-01-01'
    }
  end

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
        expect(created_user.inventory).not_to be_blank
      end
    end

    context 'with invalid attributes' do
      let(:attributes) do
        {
          name: nil,
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        }
      end

      it 'does not create the user nor the inventory' do
        expect do
          subject.call
        end.not_to(change { User.count })

        expect do
          subject.call
        end.not_to(change { Inventory.count })
        expect(subject.errors[:name]).to eq 'Should not be blank'
      end
    end
  end
end
