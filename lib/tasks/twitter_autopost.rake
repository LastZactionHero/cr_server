namespace :twitter_autopost do
  
  desc "Post Random"
  task :post_random => :environment do 
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "DIkShZJcXEyaFh1Lmv4NLg"
      config.consumer_secret     = "tyGzaVsP1cAdZvhPnCo83CuanJsxqxxq0PhMOhJoqU"
      config.access_token        = "2227696482-9uql3cjIti4WzQB0rfGB4UUuHtQMJbdOSMyiefN"
      config.access_token_secret = "6D3sLyiWxRM325nG3APYhqqjt0Dj2EuWYWR7oDcpFUUwO"
    end

    ingredient = Ingredient.visible.sample

    message = "#{ingredient.name}: #{ingredient.description}"
    message = message.slice(0,114).strip + "..."
    message += " http://digestable.co#{ingredient.path}"

    client.update(message)
  end
  
end