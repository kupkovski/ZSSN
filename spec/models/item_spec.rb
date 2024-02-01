require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cost) }

    it { should validate_numericality_of(:cost).is_greater_than_or_equal_to(0) }
  end
end
