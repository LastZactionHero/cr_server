require 'rest-client'

host = "http://localhost:3000/"
path = "labels"
url = "#{host}#{path}"

file_path = "label.jpg"

result = RestClient.post(url, {image: File.new(file_path, 'rb')})

puts result