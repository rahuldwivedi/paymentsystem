require 'rails_helper'

RSpec.describe Transaction, type: :model do

  describe 'associations' do
    it { should have_many(:children)}
    it { should belong_to(:user)}
    it { should belong_to(:parent).optional}
  end

  it "should have status enum" do
    should define_enum_for(:status).
        with_values({approved: 0, reversed: 1, refunded: 2, error: 3})
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_email) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:status) }
  end

end
