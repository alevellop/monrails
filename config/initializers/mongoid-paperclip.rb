require 'mongoid_paperclip'

Paperclip::Attachment.default_options[:storage] = :s3
# Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
# Paperclip::Attachment.default_options[:s3_protocol] = 'https'
Paperclip::Attachment.default_options[:s3_credentials] =
  { bucket: Figaro.env.s3_bucket_name,
  	access_key_id: Figaro.env.aws_access_key_id,
    secret_access_key: Figaro.env.aws_secret_access_key }

Paperclip.interpolates :courseId do |attachment, style|
  attachment.instance.course.id.to_s
end

Paperclip.interpolates :videoId do |attachment, style|
  attachment.instance.id.to_s
end