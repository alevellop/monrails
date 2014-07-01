class Profile
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :user, 	inverse_of: :profile_user, 		class_name: "User"
  belongs_to :course, inverse_of: :profile_course, 	class_name: "Course"

  validates :user_id, 	presence: true
  validates :course_id, presence: true
end
