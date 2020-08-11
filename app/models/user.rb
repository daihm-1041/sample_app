class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation).freeze
  validates  :name, presence: true,
             length: {maximum: Settings.validate.user.max_length_name}
  validates  :email, presence: true,
             length: {maximum: Settings.validate.user.max_length_email},
             format: {with: Settings.validate.user.validate_email_regex},
             uniqueness: {case_sensitive: false}
  validates  :password, presence: true,
             length: {minimum: Settings.validate.user.min_length_password}
  has_secure_password
  before_save :downcase_email
  private
  def downcase_email
    email.downcase!
  end
end
