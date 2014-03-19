namespace :twitter_autopost do
  
  desc "Post Random"
  task :post_random => :environment do 
    client = twitter_client

    ingredient = Ingredient.visible.sample

    message = "#{ingredient.name}: #{ingredient.description}"
    message = message.slice(0,114).strip + "..."
    message += " http://digestable.co#{ingredient.path}"

    client.update(message)
  end
  
  desc "Auto Favorite"
  task :auto_favorite => :environment do 
    client = twitter_client

    ingredient_search_terms.each do |search_term|
      client.search(search_term, result_type: 'recent', lang: 'en').take(3).each do |tweet|
        next if tweet.reply?
        begin
          client.favorite!(tweet)
        rescue Exception => e
        end
        sleep(30)
      end
    end
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = "DIkShZJcXEyaFh1Lmv4NLg"
      config.consumer_secret     = "tyGzaVsP1cAdZvhPnCo83CuanJsxqxxq0PhMOhJoqU"
      config.access_token        = "2227696482-9uql3cjIti4WzQB0rfGB4UUuHtQMJbdOSMyiefN"
      config.access_token_secret = "6D3sLyiWxRM325nG3APYhqqjt0Dj2EuWYWR7oDcpFUUwO"
    end
  end

  def ingredient_search_terms
    Ingredient.most_popular.limit(10).map{|i| i.name.strip}
  end

end
