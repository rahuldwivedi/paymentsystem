require "rails_helper"

RSpec.feature "Merchants List", js: true do
  describe "Index view" do
    let(:merchant) { create(:merchant, email: 'testing@yop.com') }
    let!(:merchants) { create_list(:merchant, 10) }

    it "displays all existing users" do
      visit merchants_path
      expect(page).to have_selector("tr", count: merchants.count + 1)
    end

    it "loads the show view when the 'show' icon is clicked" do
      visit merchants_path
      find("a", :text => 'Show',  match: :first).click
      expect(page).to have_current_path(merchant_path(Merchant.first))
    end

    it "loads edit view when the 'edit' icon is clicked" do
      visit merchants_path
      find("a", :text => 'Edit',  match: :first).click
      expect(page).to have_current_path(edit_merchant_path(Merchant.first))
    end

    it "destroys the user when the 'delete' icon is clicked" do
      visit merchants_path

      expect do
        page.accept_alert 'Are you sure?' do
          find("a", :text => 'Destroy',  match: :first).click
        end
        expect(page).to have_current_path(merchants_path)
      end.to change(Merchant, :count).by(-1)
    end
  end
end
