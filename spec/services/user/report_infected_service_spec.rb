# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../app/services/user/report_infected_service'

RSpec.describe Services::User::ReportInfectedService, type: :service do
  subject { described_class.new(suspect:, reporter:) }

  describe 'with valid parameters' do
    let(:suspect) do
      User.create!(name: 'John Doe', latitude: 100, longitude: 200, gender: 'male', birthdate: '1980-01-01')
    end

    let(:reporter) do
      User.create!(name: 'Clark Kent', latitude: 100, longitude: 200, gender: 'male', birthdate: '1980-01-01')
    end

    it 'creates a InfectedUserReport' do
      expect do
        expect(subject.call).to be_truthy
      end.to change { InfectedUserReport.count }.by(1)
                                                .and change { suspect.reload.infection_suspections.count }.by(1)
                                                                                                          .and change {
                                                                                                                 reporter.reload.infection_accusations.count
                                                                                                               }.by(1)
    end
  end

  describe 'with invalid parameters' do
    context 'when reporter is nil' do
      let(:suspect) do
        User.create!(name: 'John Doe', latitude: 100, longitude: 200, gender: 'male', birthdate: '1980-01-01')
      end
      let(:reporter) { nil }

      it 'returns an error for reporter nil' do
        expect do
          expect(subject.call).to eq false
        end.not_to(change { InfectedUserReport.count })
        expect(subject.errors[:reporter]).to eq 'Should not be blank'
      end
    end

    context 'when subject is nil' do
      let(:suspect) { nil }

      let(:reporter) do
        User.create!(name: 'Clark Kent', latitude: 100, longitude: 200, gender: 'male', birthdate: '1980-01-01')
      end

      it 'returns an error for subject nil' do
        expect do
          expect(subject.call).to eq false
        end.not_to(change { InfectedUserReport.count })

        expect(subject.errors[:suspect]).to eq 'Should not be blank'
      end
    end

    context 'when reporter does not exist' do
      let(:suspect) do
        User.create!(name: 'John Doe', latitude: 100, longitude: 200, gender: 'male', birthdate: '1980-01-01')
      end
      let(:reporter) { User.new }

      it 'returns an error for reporter does not exist' do
        expect do
          expect(subject.call).to eq false
        end.not_to(change { InfectedUserReport.count })
        expect(subject.errors[:reporter]).to eq 'Does not exist'
      end
    end

    context 'when subject does not exist' do
      let(:suspect) { User.new }

      let(:reporter) do
        User.create!(name: 'Clark Kent', latitude: 100, longitude: 200, gender: 'male', birthdate: '1980-01-01')
      end

      it 'returns an error for subject does not exist' do
        expect do
          expect(subject.call).to eq false
        end.not_to(change { InfectedUserReport.count })

        expect(subject.errors[:suspect]).to eq 'Does not exist'
      end
    end
  end
end
