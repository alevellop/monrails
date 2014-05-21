class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :name,            type: String
  field :email,           type: String
  field :remember_token,  type: String
  field :admin,           type: Boolean, default: false
  field :password_digest, type: String

  has_secure_password

  before_save { email.downcase! }
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  validates :password , length: { minimum: 6 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def toggle!(field)
    send "#{field}=", !self.send("#{field}?")
    save validation: false
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
