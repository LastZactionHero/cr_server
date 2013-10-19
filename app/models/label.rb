class Label < ActiveRecord::Base
  attr_accessible :filename
  
  def self.create_from_file(image)
    file_name = "label_#{DateTime.now}.png"
    file_path = "#{Rails.root}/public/system/labels/#{file_name}"
    file = File.open(file_path, "wb")
    file.write(image.read)
    file.close
    
    Label.create({filename: file_path})
  end
  
end
