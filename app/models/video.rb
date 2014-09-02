class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # TODO: validates format video

  field :title, type: String

  has_mongoid_attached_file :picture, path: Figaro.env.path_course_video

  embedded_in :course, inverse_of: :videos, class_name: "Course"

	validates :title,   presence: true,
                      uniqueness: true,
                      length: { maximum: 100 }

  # do_not_validate_attachment_file_type :picture                      
                   
  # validates_attachment_content_type :picture, content_type: ["video/mov", "video/mpeg4", "video/avi", "video/ffmepg"], 
  #                                           message: "only support 'mp4', 'mov', 'avi', 'ffmepg'"
  validates_attachment :picture, size: { less_than: 1000.megabytes }
  validates_attachment_presence :picture
end
