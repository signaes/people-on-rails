class Person < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
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
  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate_account
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_account_activation_email
    PersonMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = Person.new_token
    update_columns reset_digest: Person.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    PersonMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token  = Person.new_token
    self.activation_digest = Person.digest activation_token
  end
end
