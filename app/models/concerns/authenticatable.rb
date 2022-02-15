module Authenticatable
  extend ActiveSupport::Concern

  included do
    has_secure_password
    validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, :if => Proc.new { |t| t.has_attribute? "email" }
    validates :password, length: { within: 8..40 }, allow_nil: true
    validates :status, presence: true
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
end
