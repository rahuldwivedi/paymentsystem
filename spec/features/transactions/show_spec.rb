require 'rails_helper'

RSpec.feature "Transactions Show", js: true do
  let(:merchant) { create(:merchant) }
  let!(:transactions) { create_list(:transaction, 10, user: merchant) }
  let(:transaction) { create(:transaction, user: merchant) }

  scenario "Show Transactions" do
    visit("/transactions/#{transaction.id}")
    expect(page).to have_content('Amount')
    expect(page).to have_content(transaction.amount)
    expect(page).to have_content('Customer email:')
    expect(page).to have_content('Customer phone:')
    expect(page).to have_content('Status')
  end
end
