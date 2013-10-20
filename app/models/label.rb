class Label < ActiveRecord::Base
  attr_accessible :filename, :status, :ingredient_string
  
  before_validation :init_status, :on => :create

  validates_inclusion_of :status, :in => [:initialized, :enqueued, 
    :processing, :finished, :error]
    
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
  
  def match_ingredients!(ingredients)
    update_attributes({ingredient_string: ingredients.join("\n")})
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
