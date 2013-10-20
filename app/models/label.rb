class Label < ActiveRecord::Base
  attr_accessible :filename, :status

  has_and_belongs_to_many :ingredients
  
  before_validation :init_status, :on => :create
    
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
  
  def match_ingredients!(ingredient_names)
    update_attributes({ingredient_string: ingredient_names.join("\n")})    
    self.ingredients << Ingredient.where({name: ingredient_names})
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
