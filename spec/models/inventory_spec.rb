require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should have_many :inventory_items }
    it { should have_many :items }
  end
end
