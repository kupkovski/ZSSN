require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) } 
    it { should validate_presence_of(:birthdate) } 
    it { should validate_presence_of(:gender) } 
    it { should validate_presence_of(:latitude) } 
    it { should validate_presence_of(:longitude) } 
  end

  describe 'association' do
    it { should have_many(:infection_accusations) }
    it { should have_many(:infection_suspections) }
  end

  describe 'infected?' do
    context 'when there are no reports' do
      let(:suspect) do
        ::User.create!(
          name: 'John Doe',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      it 'assures there was no infections' do
        expect(suspect.infection_suspections.count).to eq 0
      end

      it 'returns false' do
        expect(suspect).not_to be_infected
      end
    end

    context 'when there are less than 3 reports' do
      let(:suspect) do
        ::User.create!(
          name: 'John Doe',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_1) do
        ::User.create!(
          name: 'Hard Finger',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_2) do
        ::User.create!(
          name: 'Hard Hand',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)

        expect(suspect.infection_suspections.count).to eq 2
        expect(suspect).not_to be_infected
      end
    end

    context 'when there are 3 reports but from same users' do
      let(:suspect) do
        ::User.create!(
          name: 'John Doe',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_1) do
        ::User.create!(
          name: 'Hard Finger',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_2) do
        ::User.create!(
          name: 'Hard Hand',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_1)

        expect(suspect.infection_suspections.count).to eq 3
        expect(suspect).not_to be_infected
      end
    end

    context 'when there are more than 3 reports but from same users' do
      let(:suspect) do
        ::User.create!(
          name: 'John Doe',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_1) do
        ::User.create!(
          name: 'Hard Finger',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_2) do
        ::User.create!(
          name: 'Hard Hand',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)

        expect(suspect.infection_suspections.count).to eq 4
        expect(suspect).not_to be_infected
      end
    end

    context 'when there are 3 reports but from different users' do
      let(:suspect) do
        ::User.create!(
          name: 'John Doe',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_1) do
        ::User.create!(
          name: 'Hard Finger',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_2) do
        ::User.create!(
          name: 'Hard Hand',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_3) do
        ::User.create!(
          name: 'Hard Arm',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      it 'returns false' do
        InfectedUserReport.create(suspect:, reporter: reporter_1)
        InfectedUserReport.create(suspect:, reporter: reporter_2)
        InfectedUserReport.create(suspect:, reporter: reporter_3)

        expect(suspect.infection_suspections.count).to eq 3
        expect(suspect).to be_infected
      end
    end

    context 'when there are more than 3 reports but from different users' do
      let(:suspect) do
        ::User.create!(
          name: 'John Doe',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_1) do
        ::User.create!(
          name: 'Hard Finger',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_2) do
        ::User.create!(
          name: 'Hard Hand',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_3) do
        ::User.create!(
          name: 'Hard Arm',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

      let(:reporter_4) do
        ::User.create!(
          name: 'Hard Torso',
          gender: 'male',
          latitude: 19.98,
          longitude: 29.88,
          birthdate: '1980-01-01'
        )
      end

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
