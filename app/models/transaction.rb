class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Transaction', optional: :true
  has_many :children, class_name: 'Transaction', foreign_key: 'parent_id'

  enum status: [:approved, :reversed, :refunded, :error]

  validates :amount, numericality: { greater_than: 0 }
  validates :status, :customer_email, presence: true

  scope :one_hour_old, -> { where(created_at: (Time.now - 1.hours)..Time.now) }
end

