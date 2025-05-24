require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cost) }
    it { is_expected.to validate_numericality_of(:cost).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_inclusion_of(:name).in_array(%w[água comida remédio munição]) }
  end

  describe 'associations' do
    it { should have_many(:inventories) }
    it { should have_many(:inventory_items) }
  end
end
