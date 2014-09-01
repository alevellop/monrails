class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  # TODO: refactor delete course following Chapter 9.4.2 (only admin is able to delete).
  # FIX: refactor generator_courses.haml
  # TODO: Rspec newest_courses, popular_courses, and courses.
  # TODO: Rspec title uniqueness.

  field :title, 			type: String
  field :description, type: String

  belongs_to  :author,         inverse_of: :author_of, class_name: "User"
  has_many    :profile_course, inverse_of: :course,    class_name: "Profile", dependent: :destroy
  embeds_many :videos,                                 class_name: "Video",   cascade_callbacks: true
  embeds_many :comments,                               class_name: "Comment"

  accepts_nested_attributes_for :videos

  validates :author_id, 	presence: true
  validates	:title, 			presence: true, 
                          uniqueness: true, 
                          length: { maximum: 100 }
  validates :description,	presence: true, 
                          length: { maximum: 1000 }
end
