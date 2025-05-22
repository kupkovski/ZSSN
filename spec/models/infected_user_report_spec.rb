require 'rails_helper'

RSpec.describe InfectedUserReport, type: :model do
  describe 'associations' do
    it { should belong_to :suspect }
    it { should belong_to :reporter }
  end
end
