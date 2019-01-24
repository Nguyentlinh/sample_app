class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name,  presence: true, length: {maximum: Settings.name_maximum}
  validates :email, presence: true, length: {maximum: Settings.email_maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.password_minimum}
  before_save :downcase_email
  has_secure_password

  private

  def email_downcase
    email.downcase!
  end
end
