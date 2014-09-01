class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :course, inverse_of: :comments, class_name: "Course"

  field :body,		type: String

  validates :body, presence: true, length: {maximum: 140}
end
