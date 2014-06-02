class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  # TODO: check test to unique title.
  # TODO: refactor delete course following Chapter 9.4.2 (only admin is able to delete).

  field :title, 			type: String
  field :description, type: String

  belongs_to :author, inverse_of: :author_of, class_name: "User"

  validates :author_id, 	presence: true
  validates	:title, 			presence: true, length: { maximum: 100 }
  validates :description,	presence: true, length: { maximum: 300 }
end
