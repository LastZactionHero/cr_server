require 'rest-client'

host = "http://yuccasix.com/"
path = "labels/4"
url = "#{host}#{path}"

result = RestClient.get(url)

puts result