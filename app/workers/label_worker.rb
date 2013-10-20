require 'ocr'

class LabelWorker
  include Sidekiq::Worker
  
  def perform(label_id)
    label = Label.find(label_id)
    label.processing!
    
    ingredients = Ocr.new.start(label.filename)
    label.match_ingredients!(ingredients)
    
    label.finished!
  end
  
end