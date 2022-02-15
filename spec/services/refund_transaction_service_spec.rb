require 'rails_helper'

describe RefundTransactionService do
  let(:merchant) { create(:merchant) }
  let(:charge) { create(:charge, user: merchant) }

  describe "Transaction authorize and refund" do
    let(:transaction_params) { { amount: 10, customer_email: 'tst@yopmail.com'} }

    it 'pass valid params' do
      transaction = RefundTransactionService.call(transaction: charge, current_user: merchant)
      expect(transaction.success?).to be_truthy
    end

    it 'Should create Refund' do
      expect do
        RefundTransactionService.call(transaction: charge, current_user: merchant)
      end.to change { Refund.count }.by(1)
      expect(Refund.last.amount).to eq charge.amount
      expect(Refund.last.status).to eq 'approved'
    end

    it 'Should update user amount' do
      after_transaction_amount = merchant.amount + charge.amount
      RefundTransactionService.call(transaction: charge, current_user: merchant)
      expect(merchant.amount).to eq after_transaction_amount
    end
  end
end
