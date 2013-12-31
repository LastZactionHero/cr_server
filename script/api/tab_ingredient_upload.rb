require 'rest-client'

def parse_line(line)
  data = line.split("\t")
  {
    id: data[0],
    name: data[1],
    technical_effects: data[2],
    description: data[3]
  }
end

def update_ingredient(ingredient)
  #url = "http://foodstuffapp.com/ingredients/#{ingredient[:id]}"
  url = "http://localhost:3000/ingredients/5219"
  
  begin
  RestClient.put url, 
    ingredient: {description: ingredient[:description]}
  rescue Exception => e
    puts "Failed updating #{ingredient[:name]}"
  end
end

puts "Uploading Ingredient Descriptions"

filename = ARGV[0]
file = File.open(filename, 'r')
lines = file.readlines
lines.delete_at(0)

lines.each do |line|
  ingredient = parse_line(line)
  puts "Updating #{ingredient[:id]}: #{ingredient[:name]}"
  update_ingredient(ingredient)
end