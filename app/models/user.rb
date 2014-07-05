class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
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
  has_mongoid_attached_file :image, 
                            styles: { thumb: "9x14", small: "10x15", medium: "15x20" },
                            url: "s3_eu_url",
                            path: "users/:id_:style_:basename.:extension"

  has_many  :author_of,    inverse_of: :author, class_name: "Course",  dependent: :destroy
  has_many  :profile_user, inverse_of: :user,   class_name: "Profile", dependent: :destroy

  before_save { email.downcase! }
  before_create :create_remember_token

  validates_attachment :image, size: { less_than: 3.megabytes },
                        content_type: { content_type: ["image/jpeg", "image/jpg", "image/png"] }
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
