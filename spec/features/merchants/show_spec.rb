require "rails_helper"

RSpec.feature "Merchant Shoe", js: true do

  describe "#show view" do
    let(:merchant) { create(:merchant, email: 'testing@yop.com') }

    it "displays all public attributes" do
      visit merchant_path(merchant)
      [
        "Name: #{merchant.name}",
        "Email: #{merchant.email}",
        "Status: #{merchant.status}",
        "Amount: #{merchant.amount}",
        "Total transaction sum: #{merchant.total_transaction_sum}"
      ].each do |text|
        expect(page).to have_text text
      end
    end
  end
end
