class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    
    Ingredient.reset_column_information
    
    filename = "#{Rails.root}/lib/additives/additive_list.txt"
    
    file = File.open(filename, "r")
    list = file.readlines.map{|i| i.strip}
    file.close
    
    list.each do |ingredient|
      name = ingredient.split(" ").map{|i| i.downcase.capitalize}.join(" ")
      Ingredient.create({name: name})
    end
    
  end
end
