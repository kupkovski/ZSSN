require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:birthdate) }

    it { should validate_numericality_of(:latitude) }
    it { should validate_numericality_of(:longitude) }
  end

  describe 'infected?' do
    context 'when there are no reports' do
      let(:suspect) {
        User.create!(
          name: "John Doe",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      it 'returns false' do
        expect(suspect.infection_suspections.count).to eq 0
        expect(suspect).to_not be_infected
      end
    end

    context 'when there are less than 3 reports' do
      let(:suspect) {
        User.create!(
          name: "John Doe",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_1) {
        User.create!(
          name: "Hard Finger",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_2) {
        User.create!(
          name: "Hard Hand",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)

        expect(suspect.infection_suspections.count).to eq 2
        expect(suspect).to_not be_infected
      end
    end

    context 'when there are 3 reports but from same users' do
      let(:suspect) {
        User.create!(
          name: "John Doe",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_1) {
        User.create!(
          name: "Hard Finger",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_2) {
        User.create!(
          name: "Hard Hand",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_1)

        expect(suspect.infection_suspections.count).to eq 3
        expect(suspect).to_not be_infected
      end
    end

    context 'when there are more than 3 reports but from same users' do
      let(:suspect) {
        User.create!(
          name: "John Doe",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_1) {
        User.create!(
          name: "Hard Finger",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_2) {
        User.create!(
          name: "Hard Hand",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)

        expect(suspect.infection_suspections.count).to eq 4
        expect(suspect).to_not be_infected
      end
    end

    context 'when there are 3 reports but from different users' do
      let(:suspect) {
        User.create!(
          name: "John Doe",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_1) {
        User.create!(
          name: "Hard Finger",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_2) {
        User.create!(
          name: "Hard Hand",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_3) {
        User.create!(
          name: "Hard Arm",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_3)

        expect(suspect.infection_suspections.count).to eq 3
        expect(suspect).to be_infected
      end
    end

    context 'when there are more than 3 reports but from different users' do
      let(:suspect) {
        User.create!(
          name: "John Doe",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_1) {
        User.create!(
          name: "Hard Finger",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_2) {
        User.create!(
          name: "Hard Hand",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_3) {
        User.create!(
          name: "Hard Arm",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      let(:reporter_4) {
        User.create!(
          name: "Hard Torso",
          gender: "male",
          latitude: 19.98,
          longitude: 29.88,
          birthdate: "1980-01-01"
        )
      }

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_3)
        InfectedUserReport.create(suspect:, reporter: reporter_4)

        expect(suspect.infection_suspections.count).to eq 4
        expect(suspect).to be_infected
      end
    end
  end
end
