require 'rails_helper'
require 'active_model_serializers'

RSpec.describe UserSerializer do
  subject { described_class.new(user) } 

  let(:user) { User.create!(name: 'Testing Joe', birthdate: Date.today - 2.years, gender: 'male', latitude: -58.0, longitude: -57.0, infected: false) }
  
  it 'returns the correct json for it' do
    expect(subject.to_json).to eq({
      id: user.id,
      name: user.name,
      age: 2,
      gender: 'male',
      latitude: user.latitude,
      longitude: user.longitude,
      infected: false
    }.to_json)
  end

end
