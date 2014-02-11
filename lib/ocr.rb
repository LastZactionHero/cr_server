begin
require 'fuzzystringmatch'
rescue Exception => e
end

class Ocr
  attr_accessor :ingredient_list
  
  class Word
    attr_accessor :word, :match, :ingredient    
    def initialize word
      @word = word
      @match = 0.0
      @ingredient = nil
    end    
    
    def to_s
      "#{word} - #{match} - #{ingredient}"
    end
    
    def to_hash
      {source_word: word, similarity: match, ingredient: ingredient}
    end
  end
  
  # Split on commas into BLOCKS

  def start(filename)
    @ingredient_list = read_ingredient_list
    
    text = text_from_image(filename)

    text.gsub!(/\n/, " ")
    text.gsub!(/\./, "")
    text.gsub!(/[ \t]+/, " ")
  
    blocks = text.split(",").map{|block| block.strip}

    ingredients = []
    blocks.each{|b| ingredients << process_block(b)}
    ingredients.flatten!

    ingredients.map!{|i| i.to_hash}
    
    output = Hash.new
    
    ingredients.each do |i|
      key = i[:ingredient]
      if output.has_key?(key)
        output[key] = i if output[key][:similarity] <= i[:similarity]
      else
        output[key] = i
      end
    end
    
    filter_poor_results!(output)

    output
  end
  
  private
  
  POOR_RESULT_THRESHOLD = 0.85

  def filter_poor_results!(results)
    results.keys.each do |k|
      results.delete(k) and next unless k
      results.delete(k) if results[k][:similarity] < POOR_RESULT_THRESHOLD
    end

    results
  end

  def text_from_image(image_filename)
    output_filename = "ocr_#{SecureRandom.hex(10)}"
    system("tesseract #{image_filename} #{output_filename} -l eng")

    output_file = File.open("#{output_filename}.txt", 'r')
    text = output_file.read
    output_file.close

    text
  end

  def process_block(block)    
    words = block.split(" ").map{|w| Word.new(w)}
    
    (1..words.length).each do |n|
      available_groups = words.length - n + 1
      
      (0..available_groups - 1).each do |g|

        word_block = words.slice(g,n)
        word_string = word_block.map{|w| w.word}.join(" ").strip
        
        nearest_match = match_ingredient(word_string)

        word_block_average = 0
        word_block.each do |word|
          word_block_average += word.match
        end
        word_block_average = word_block_average / word_block.length

        if nearest_match[:distance] >= word_block_average
          word_block.each do |word|
            word.match = nearest_match[:distance]
            word.ingredient = nearest_match[:ingredient]
          end
        end

        # word_block.each do |word|
        #   if nearest_match[:distance] >= word.match
        #     word.match = nearest_match[:distance]
        #     word.ingredient = nearest_match[:ingredient]
        #   end            
        # end
        
      end
    end
    
    words
  end
  
  def match_ingredient words
    nearest = {:ingredient => nil, :distance => 0.0}
      
    @ingredient_list.each do |ingredient|
      jarow = FuzzyStringMatch::JaroWinkler.create(:native)
      distance = jarow.getDistance(ingredient.upcase, words)
      distance = adjust_distance(distance, {ingredient: ingredient, words: words})
      if distance > nearest[:distance] && distance > 0.75
        nearest[:distance] = distance
        nearest[:ingredient] = ingredient
      end      
    end
    
    nearest
  end
  
  def adjust_distance(distance, options = {})
    modified_distance = distance

    if options[:words]
      # Only allow ingredients >= 4 characters long
      if options[:words].length < 4
        modified_distance = 0
      end
    end

    modified_distance
  end
  
  def read_ingredient_list
    Ingredient.name_list
  end
  
end