class Person < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save :downcase_email
  has_secure_password

  validates :name, length: { maximum: 60 }
  validates :password, length: { minimum: 6 }, presence: true
  validates :password_confirmation, length: { minimum: 6 }, presence: true
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  private

  def downcase_email
    email.downcase!
  end
end
