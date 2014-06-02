class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  # TODO: check errors in user_pages_spec.rb (lines: 79 - 81).
  # TODO: refactor created_courses in 'view/users/show' following Chapter 10.3.3.
  # TODO: Chapter 10, exercises 1, 2, 3 (user_path version), 5, and 7.

  field :name,            type: String
  field :email,           type: String
  field :remember_token,  type: String
  field :admin,           type: Boolean, default: false
  field :password_digest, type: String

  has_secure_password

  has_many :author_of, inverse_of: :author, class_name: "Course", dependent: :destroy

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
