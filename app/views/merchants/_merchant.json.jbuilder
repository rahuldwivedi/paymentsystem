json.extract! merchant, :id, :name, :email, :type, :status, :amount, :total_transaction_sum, :created_at, :created_at, :updated_at
json.url merchant_url(merchant, format: :json)
