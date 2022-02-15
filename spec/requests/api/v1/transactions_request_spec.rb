require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:merchant) { create(:merchant) }
  let(:token) { JsonWebToken.encode(user_id: merchant.id, exp: 24.hours.from_now, user_type: 'User') }
  let(:headers) { {"AUTHORIZATION" => "Basic #{token}"} }
  before do

  end

  describe "Transaction authorize" do
    let(:transaction_params) { { amount: 10, customer_email: 'tst@yopmail.com'} }

    it "creates a new Authorize" do
      expect {
        post authorize_transactions_url, params: { transaction: transaction_params }, headers: headers
      }.to change(Authorize, :count).by(1)
      expect(Authorize.last.amount).to eq transaction_params[:amount]
      expect(Authorize.last.status).to eq 'approved'
    end

    it 'Should create Charge' do
      expect do
        post authorize_transactions_url, params: { transaction: transaction_params }, headers: headers
      end.to change { Charge.count }.by(1)
      expect(Charge.last.amount).to eq transaction_params[:amount]
      expect(Charge.last.status).to eq 'approved'
    end

    it 'Should return false and return error' do
      post authorize_transactions_url, params: { transaction: {amount: 0} }, headers: headers
      json_response = JSON.parse(response.body)
      expect(json_response[:status]).to be_falsy
      expect(json_response['errors'][0]['amount']).to eq "must be greater than 0"
    end

    it 'Should update user amount' do
      after_transaction_amount = merchant.amount - transaction_params[:amount]
      post authorize_transactions_url, params: { transaction: transaction_params }, headers: headers
      merchant.reload
      expect(merchant.amount).to eq after_transaction_amount
    end
  end

  describe "Transaction reversal" do
    let(:transaction_params) { { amount: 10000, customer_email: 'tst@yopmail.com'} }

    it 'Should return true' do
      expect {
        post authorize_transactions_url, params: { transaction: transaction_params }, headers: headers
      }.to change(Authorize, :count).by(1)
      expect(Authorize.last.amount).to eq transaction_params[:amount]
      expect(Authorize.last.status).to eq 'reversed'
    end

    it 'Should create Reversal' do
      expect do
        post authorize_transactions_url, params: { transaction: transaction_params }, headers: headers
      end.to change { Reversal.count }.by(1)
      expect(Reversal.last.amount).to eq transaction_params[:amount]
      expect(Reversal.last.status).to eq 'approved'
    end
  end

  describe "Transaction authorize and refund" do
    let(:transaction_params) { { amount: 10, customer_email: 'tst@yopmail.com'} }
    let(:charge) { create(:charge, user: merchant) }

    it 'pass valid params' do
      post refund_transaction_url(charge), params: { transaction: transaction_params }, headers: headers
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be_truthy
    end

    it 'Should create Refund' do
      expect do
        post refund_transaction_url(charge), params: { transaction: transaction_params }, headers: headers
      end.to change { Refund.count }.by(1)
      expect(Refund.last.amount).to eq charge.amount
      expect(Refund.last.status).to eq 'approved'
    end

    it 'Should update user amount' do
      after_transaction_amount = merchant.amount + charge.amount
      post refund_transaction_url(charge), params: { transaction: transaction_params }, headers: headers
      expect(merchant.reload.amount).to eq after_transaction_amount
    end
  end
end
