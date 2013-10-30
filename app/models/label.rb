class Label < ActiveRecord::Base
  attr_accessible :filename, :status, :rating

  has_many :matches
  has_many :ingredients, :through => :matches
  
  before_validation :init_status, :on => :create
  validates :rating, inclusion: { in: [nil, 1, 2, 3, 4, 5]}
  
  def similarity
    return 0 if matches.empty?    
    matches.map{|m| m.similarity}.inject(:+) / matches.count
  end
  
  def self.create_from_file(image)
    label = Label.create
    label.save_file!(image)
    label
  end

  def save_file!(image)
    filename = generate_filename
    
    file = File.open(filename, "wb")
    file.write(image.read)
    file.close
    
    update_attributes({:filename => filename})
  end
  
  def match_ingredients!(ingredient_matches)
        
    ingredient_matches.keys.each do |k|
      data = ingredient_matches[k]
      
      ingredient = Ingredient.find_by_name data[:ingredient]
      if ingredient
       Match.create({label_id: id, ingredient_id: ingredient.id, similarity:
         data[:similarity]})
      end
    end
  end
  
  def ingredient_string
    ingredients.pluck(:name).join(" ")
  end
    
  def queue!
    update_attributes({:status => :enqueued})
    LabelWorker.delay_for(1.second).perform_async(id)
  end
  
  def processing!
    update_attributes({:status => :processing})
  end
  
  def finished!
    update_attributes({:status => :finished})    
  end
  
  def error!
    update_attributes({:status => :error})    
  end
  
  private
    
  def generate_filename
    name = "label_#{id}_#{DateTime.now}.png"
    path = "#{Rails.root}/public/system/labels/"
    "#{path}#{name}"
  end
  
  def init_status
    self.status = :initialized
  end
  
end
