require 'rest-client'

host = "http://api.lvh.me:3000/"
path = "labels/11/rate.json"
url = "#{host}#{path}"

result = RestClient.put(url, {rating: 2})

puts result