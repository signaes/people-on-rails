class Person < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email
  has_secure_password

  validates :name, length: { maximum: 60 }

  password_validation = { length: { minimum: 6 }, presence: true, allow_nil: true }
  validates :password, password_validation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers the user in the database for use in persistent sessions.
  def remember
    self.remember_token = Person.new_token
    update_attribute :remember_digest, Person.digest(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private

  def downcase_email
    self.email.downcase!
  end
end
