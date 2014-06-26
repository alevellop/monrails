class Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :comment, 	type: String
  field :course_id, type: String

  belongs_to :user, 	inverse_of: :profile_user, 		class_name: "User"
  belongs_to :course, inverse_of: :profile_course, 	class_name: "Course"

  validates :user_id, 	presence: true
  validates :course_id, presence: true
  validates :comment, length: { maximum: 140 }
end
