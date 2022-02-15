module Api
  module V1
    class TransactionsController < Api::V1::ApiController
      before_action :authenticate_request
      before_action :user_active?
      before_action :set_transaction, only: [:refund]

      def authorize
        transaction = TransactionService.call(transaction_params: transaction_params, current_user: current_user)
        if transaction.success?
          render_success_response({}, I18n.t('created', resource: 'Transaction'))
        else
          render_unprocessable_entity(transaction.errors)
        end
      end

      def refund
        transaction = RefundTransactionService.call(transaction: @transaction, current_user: current_user)
        if transaction.success?
          render_success_response({}, I18n.t('created', resource: 'Transaction'))
        else
          render_unprocessable_entity(transaction.errors)
        end
      end

      private

      def set_transaction
        @transaction = current_user.transactions.find(params[:id])
      end

      def user_active?
        render_unauthorized_response({inactive: I18n.t('errors.inactive_account')}) and return unless current_user.active?
      end

      def transaction_params
        params.require(:transaction).permit(:amount, :customer_email, :customer_phone)
      end
    end
  end
end
