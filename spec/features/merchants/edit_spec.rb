require "rails_helper"

RSpec.feature "Merchant Edit", js: true do

  describe "#show view" do
    let(:merchant) { create(:merchant, email: 'testing@yop.com') }
    describe "#edit view" do
      it "update all public attributes" do
        visit edit_merchant_path(merchant)

        fill_in 'merchant_name', :with => 'Hero'
        click_button "Update Merchant"
        expect(page).to have_current_path(merchant_path(merchant))
        expect(page).to have_text "successfully updated."
        expect(page).to have_text "Name: Hero"
      end
    end
  end
end
