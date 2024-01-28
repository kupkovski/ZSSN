require 'rails_helper'
require_relative '../../../app/services/user/report_infected_service'

RSpec.describe Services::User::ReportInfectedService, type: :service do
  subject { described_class.new(suspect: suspect, reporter: reporter) }

  describe 'with valid parameters' do
    let(:suspect) {
      User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    let(:reporter) {
      User.create!(name: "Clark Kent", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
    }

    it 'creates a InfectedUserReport' do
      expect do
        expect(subject.call).to be_truthy
      end.to change { InfectedUserReport.count }.by(1)
      .and change { suspect.reload.infection_suspections.count }.by(1)
      .and change { reporter.reload.infection_accusations.count }.by(1)
    end
  end

  describe 'with invalid parameters' do
    context 'when reporter is nil' do
      let(:suspect) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }
      let(:reporter) { nil }

      it 'returns an error for reporter nil' do
        expect do
          expect(subject.call).to eq false
        end.to_not change { InfectedUserReport.count }
        expect(subject.errors[:reporter]).to eq 'Should not be blank'
      end
    end

    context 'when subject is nil' do
      let(:suspect) { nil }

      let(:reporter) {
        User.create!(name: "Clark Kent", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }

      it 'returns an error for subject nil' do
        expect do
          expect(subject.call).to eq false
        end.to_not change { InfectedUserReport.count }

        expect(subject.errors[:suspect]).to eq 'Should not be blank'
      end
    end

    context 'when reporter does not exist' do
      let(:suspect) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }
      let(:reporter) { User.new }

      it 'returns an error for reporter does not exist' do
        expect do
          expect(subject.call).to eq false
        end.to_not change { InfectedUserReport.count }
        expect(subject.errors[:reporter]).to eq 'Does not exist'
      end
    end

    context 'when subject does not exist' do
      let(:suspect) { User.new }

      let(:reporter) {
        User.create!(name: "Clark Kent", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }

      it 'returns an error for subject does not exist' do
        expect do
          expect(subject.call).to eq false
        end.to_not change { InfectedUserReport.count }

        expect(subject.errors[:suspect]).to eq 'Does not exist'
      end
    end
  end
end
