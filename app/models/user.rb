class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  before_create { generate_token(:auth_token) }
  after_initialize :init
  
  validates :email, :password, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }
  validates :email, uniqueness: true, format: { with: /@/ , message: "invalid email format." }

  def init
    self.confirmed  ||= false           #will set the default value only if it's nil
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def generate_token(column)
    begin 
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def send_confirmation_email
    generate_token(:confirmation_token)
    self.confirmation_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.confirmation_email(self).deliver
  end
end