class TransactionService < ApplicationService

  def initialize(transaction_params:, current_user:)
    @transaction_params = transaction_params.merge({status: 'approved', user_id: current_user.id})
    @current_user = current_user
  end

  private

  attr_accessor :transaction_params, :current_user, :authorize_trans

  def call
    @authorize_trans = Authorize.new(transaction_params)
    if @authorize_trans.save
      ActiveRecord::Base.transaction do
        current_user.lock!
        has_amount? ? charge : reversal
      end
    else
      errors.add_multiple_errors @authorize_trans.errors.messages
    end
  end

  def charge
    current_user.amount -= authorize_trans.amount
    charge_trans = Charge.create!(transaction_param)
    current_user.total_transaction_sum = charge_trans.amount
    current_user.save!
  end

  def reversal
    reversal_trans = Reversal.create!(transaction_param)
    authorize_trans.reversed!
  end

  def has_amount?
    current_user.amount >= authorize_trans.amount
  end

  def transaction_param
    {amount: authorize_trans.amount, status: 'approved', user: current_user, parent: authorize_trans, customer_email: authorize_trans.customer_email}
  end
end
