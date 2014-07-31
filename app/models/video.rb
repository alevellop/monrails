class Video
  include Mongoid::Document
  include Mongoid::Paperclip

  # TODO: validates format video

  field :title, type: String

  # has_mongoid_attached_file :picture,
  													# styles: { big: '500x500', medium: '300x300' },
  													# path: Figaro.env.path_video_course,
  													# default_style: :medium

  embedded_in :course, inverse_of: :videos, class_name: "Course"

	validates            :title,   presence: true, length: { maximum: 100 }
	# validates_attachment :picture, presence: true
end
