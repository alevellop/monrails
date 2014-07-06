Paperclip::Attachment.default_options[:url] 	= ":s3_eu_url"
Paperclip::Attachment.default_options[:path] 	= "/:class/:id_partition/:style/:filename"

# Paperclip.interpolates(:s3_eu_url) do |att, style|
# 	"#{att.s3_protocol}://s3-website-eu-west-1.amazonaws.com/#{att.bucket_name}/#{att_path(style)}"
# end