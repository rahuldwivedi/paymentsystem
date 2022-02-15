class AuthenticateUser < ApplicationService
  def initialize(email, password, remember_me = false)
    @email = email
    @password = password
  end

  private

  attr_accessor :email, :password, :remember_me

  def call
    expiry = 24.hours.from_now
    user ||= authenticate_user
    if user
      { token: JsonWebToken.encode(user_id: user.id, exp: expiry, user_type: 'User'), user: allowed_attributes(user) }
    end
  end

  def authenticate_user
    user = User.find_by(email: email)
    return user if user.present? && user&.authenticate(password)
    errors.add :detail, I18n.t('errors.invalid_credentials')
  end

  def allowed_attributes(user)
    user.attributes.except('password_digest')
  end
end
