class Merchant < User

  before_destroy do
    cannot_delete_with_transactions
    throw(:abort) if errors.present?
  end

  def cannot_delete_with_transactions
    errors.add(:base, 'Cannot delete Merchant with transactions') if transactions.any?
  end
end
