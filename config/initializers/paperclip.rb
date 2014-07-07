Paperclip::Attachment.default_options[:url] 					= ":s3_us_url"
Paperclip::Attachment.default_options[:path] 					= "/:class/:attachment/:id_partition/:style/:filename"
# Paperclip::Attachment.default_options[:s3_host_alias] = "monrails.s3-website-us-east-1.amazonaws.com"

# Paperclip.interpolates(:s3_eu_url) do |att, style|
# 	"#{att.s3_protocol}://app-monrails.herokuapp.com.s3-website-eu-west-1.amazonaws.com/#{att.bucket_name}/#{att_path(style)}"
# end