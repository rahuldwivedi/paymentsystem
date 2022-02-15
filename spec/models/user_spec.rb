require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:transactions)}

  it "should have status enum" do
    should define_enum_for(:status).
        with_values({inactive: 0, active: 1})
  end
end
