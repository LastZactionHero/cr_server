require 'rest-client'

host = "http://api.lvh.me:3000/"
path = "labels/11.json"
url = "#{host}#{path}"

result = RestClient.get(url)

puts result