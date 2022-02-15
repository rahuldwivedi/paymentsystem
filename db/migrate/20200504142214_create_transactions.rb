class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :transactions, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.float :amount
      t.references :user, index: true
      t.references :parent, index: true
      t.string :customer_email
      t.string :customer_phone
      t.integer :status, default: 0
      t.string :type
      t.timestamps
    end
  end
end
