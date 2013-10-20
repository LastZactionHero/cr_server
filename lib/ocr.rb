require 'fuzzystringmatch'

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
  end
  
  # Split on commas into BLOCKS

  def start(filename)
    @ingredient_list = read_ingredient_list
    
    e = init_tesseract
    text = e.text_for(filename)
    text.gsub!(/\n/, " ")
    text.gsub!(/\./, "")
        
    blocks = text.split(",").map{|block| block.strip}
    
    ingredients = []
    blocks.each{|b| ingredients << process_block(b)}
    ingredients.flatten!
  end
  
  private
  
  def process_block(block)    
    words = block.split(" ").map{|w| Word.new(w)}
    
    (1..words.length).each do |n|
      available_groups = words.length - n + 1
      
      (0..available_groups - 1).each do |g|

        word_block = words.slice(g,n)
        word_string = word_block.map{|w| w.word}.join(" ").strip
        
        nearest_match = match_ingredient(word_string)
        
        word_block.each do |word|
          if nearest_match[:distance] >= word.match
            word.match = nearest_match[:distance]
            word.ingredient = nearest_match[:ingredient]
          end            
        end
        
      end
    end
    
          
    ingredients = words.map{|w| w.ingredient}.uniq
    ingredients
  end
  
  def match_ingredient words
    nearest = {:ingredient => nil, :distance => 0.0}
      
    @ingredient_list.each do |ingredient|
      jarow = FuzzyStringMatch::JaroWinkler.create(:native)
      distance = jarow.getDistance(ingredient, words)
      if distance > nearest[:distance]
        nearest[:distance] = distance
        nearest[:ingredient] = ingredient
      end      
    end
    
    nearest
  end
  
  def init_tesseract
    e = Tesseract::Engine.new {|e|
      e.language  = :eng
      e.whitelist = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ,()[]%.1234567890#'
    }
  end
  
  def read_ingredient_list
    filename = "#{Rails.root}/lib/additives/additive_list.txt"
    
    file = File.open(filename, "r")
    list = file.readlines.map{|i| i.strip}
    file.close
    
    list
  end
  
end