class OldTransactionDeleter
  include Sidekiq::Worker

  def perform(*args)
    Transaction.one_hour_old.destroy_all
  end
end
