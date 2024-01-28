require 'rails_helper'
require_relative '../../../app/services/user/update_location_service'

RSpec.describe Services::User::UpdateLocationService, type: :service do
  subject { described_class.new(user: user, latitude: latitude, longitude: longitude) }

  describe 'with valid parameters' do
    let(:latitude) { -99 }
    let(:longitude) { -88 }
    let(:user) {
      User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    it 'updates the user lat an long attributes' do
      expect(subject.call).to eq true
      user.reload
      expect(user.latitude).to eq -99
      expect(user.longitude).to eq -88
    end
  end

  describe 'with invalid parameters' do
    context 'when user is nil' do
      let(:user) { nil }
      let(:latitude) { -99 }
      let(:longitude) { -88 }

      it 'returns an error for user nil' do
        expect(subject.call).to be false
        expect(subject.errors[:user]).to eq 'Should not be blank'
      end
    end

    context 'when lat is nil' do
      let(:user) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }
      let(:latitude) { nil}
      let(:longitude) { -88 }

      it 'returns an error for user nil' do
        expect(subject.call).to be false
        expect(subject.errors[:latitude]).to eq 'Should not be blank'
      end
    end

    context 'when lon is nil' do
      let(:user) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }
      let(:latitude) { 99}
      let(:longitude) { nil }

      it 'returns an error for user nil' do
        expect(subject.call).to be false
        expect(subject.errors[:longitude]).to eq 'Should not be blank'
      end
    end

    context 'when lat is not numeric' do
      let(:user) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }
      let(:latitude) { 'abc' }
      let(:longitude) { 88 }

      it 'returns an error for user nil' do
        expect(subject.call).to be false
        expect(subject.errors[:latitude]).to eq 'Should be numeric'
      end
    end

   context 'when lat is not numeric' do
      let(:user) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }
      let(:latitude) { 99 }
      let(:longitude) { 'def' }

      it 'returns an error for user nil' do
        expect(subject.call).to be false
        expect(subject.errors[:longitude]).to eq 'Should be numeric'
      end
    end
  end
end
