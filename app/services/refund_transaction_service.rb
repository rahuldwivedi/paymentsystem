class RefundTransactionService < ApplicationService

  def initialize(transaction:, current_user:)
    @transaction = transaction
    @current_user = current_user
  end

  private

  attr_accessor :transaction, :current_user

  def call
    if transaction.approved?
      ActiveRecord::Base.transaction do
        current_user.lock!
        refund
      end
    else
      errors.add :detail, I18n.t('errors.approved_transaction')
    end
  end

  def refund
    current_user.total_transaction_sum -= transaction.amount
    refund_trans = Refund.create(amount: transaction.amount, status: "approved", user: current_user, parent: transaction, customer_email: transaction.customer_email)
    current_user.amount += refund_trans.amount
    transaction.refunded!
    current_user.save!
  end
end
