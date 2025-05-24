require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
    it { should belong_to(:inventory) }
  end
end
