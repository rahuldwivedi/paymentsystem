require 'rails_helper'

RSpec.feature "Transactions", type: :feature do
  let(:merchant) { create(:merchant) }
  let!(:transactions) { create_list(:transaction, 10, user: merchant) }

  scenario "List Transactions" do
    visit('/')
    expect(page).to have_selector('table tr')
    expect(page).to have_content('Transactions')
  end
end
