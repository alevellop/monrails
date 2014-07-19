class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include ActiveModel::SecurePassword

  # TODO: check errors in user_pages_spec.rb (lines: 79 - 81).
  # TODO: refactor created_courses in 'view/users/show' following Chapter 10.3.3.
  # TODO: Chapter 10, exercises 1, 2, 3 (user_path version), 5, and 7.
  # TODO: Rspec for :photo
  # TODO: add action 'delete user himself'

  field :name,            type: String
  field :email,           type: String
  field :remember_token,  type: String
  field :admin,           type: Boolean, default: false
  field :password_digest, type: String

  has_secure_password
  has_mongoid_attached_file :photo,
                            styles: { medium: '300x300' ,thumb: '100x100', small: '150x150' },
                            default_url: Figaro.env.url_default_user_photo,
                            path: Figaro.env.path_user_photo,
                            default_style: :small

  has_many  :author_of,    inverse_of: :author, class_name: "Course",  dependent: :destroy
  has_many  :profile_user, inverse_of: :user,   class_name: "Profile", dependent: :destroy

  before_save { email.downcase! }
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  validates :password , length: { minimum: 6 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates_attachment :photo, 
    size:         { less_than: 3.megabytes }, 
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

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
