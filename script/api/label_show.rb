require 'rest-client'

host = "http://localhost:3000/"
path = "labels/4"
url = "#{host}#{path}"

result = RestClient.get(url)

puts result