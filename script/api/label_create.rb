require 'rest-client'

host = "http://yuccasixcom/"
path = "labels"
url = "#{host}#{path}"

file_path = "label.jpg"

result = RestClient.post(url, {image: File.new(file_path, 'rb')})

puts result