require 'rails_helper'

describe TransactionService do
  let(:merchant) { create(:merchant) }

  describe "Transaction authorize" do
    let(:transaction_params) { { amount: 10, customer_email: 'tst@yopmail.com'} }

    it 'pass valid params' do
      transaction = TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      expect(transaction.success?).to be_truthy
    end

    it 'Should create Authorize' do
      expect do
        TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      end.to change { Authorize.count }.by(1)
      expect(Authorize.last.amount).to eq transaction_params[:amount]
      expect(Authorize.last.status).to eq 'approved'
    end

    it 'Should create Charge' do
      expect do
        TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      end.to change { Charge.count }.by(1)
      expect(Charge.last.amount).to eq transaction_params[:amount]
      expect(Charge.last.status).to eq 'approved'
    end

    it 'Should return false' do
      transaction = TransactionService.call(transaction_params: {}, current_user: merchant)
      expect(transaction.success?).to be_falsy
      expect(transaction.errors.keys).to eq [:amount, :customer_email]
    end

    it 'Should update user amount' do
      after_transaction_amount = merchant.amount - transaction_params[:amount]
      TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      expect(merchant.amount).to eq after_transaction_amount
    end
  end

  describe "Transaction reversal" do
    let(:transaction_params) { { amount: 10000, customer_email: 'tst@yopmail.com'} }

    it 'Should return true' do
      transaction = TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      expect(transaction.success?).to be_truthy
    end

    it 'Should create Authorize' do
      expect do
        TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      end.to change { Authorize.count }.by(1)
      expect(Authorize.last.amount).to eq transaction_params[:amount]
      expect(Authorize.last.status).to eq 'reversed'
    end

    it 'Should create Reversal' do
      expect do
        TransactionService.call(transaction_params: transaction_params, current_user: merchant)
      end.to change { Reversal.count }.by(1)
      expect(Reversal.last.amount).to eq transaction_params[:amount]
      expect(Reversal.last.status).to eq 'approved'
    end
  end
end
