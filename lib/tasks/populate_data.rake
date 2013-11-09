require 'wikipedia'

namespace :populate_data do
  
  desc "Populate Regulatory Statuses"
  task :regulatory_statuses => :environment do 
    RegulatoryStatus.destroy_all
    
    [ {abbreviation: "BAN", name: "Banned Substance", description: "Substances banned prior to the Food Additives Amendment (FAA) because of toxicity."},
      {abbreviation: "FS",  name: "Standardized Food", description: "Substances permitted as optional ingredient in a standardized food"},
      {abbreviation: "GRAS", name: "Generally Recognized as Safe", description: "Most GRAS substances have no quantitative restrictions as to use, although their use must conform to good manufacturing practices."},
      {abbreviation: "GRAS/FS", name: "Generally Recognized as Safe in Food", description: "Substances generally recognized as safe in foods but limited in standardized foods where the standard provides for its use."},
      {abbreviation: "ILL", name: "Illegal Substance", description: "Substances used or proposed for use as direct additives in foods without required clearance under the FAA. Their use is illegal."},
      {abbreviation: "PD", name: "Petition Denied", description: "Substances for which a petition has been filed but denied because of lack of proof of safety. Substances in this category are illegal and may not be used in foods."},
      {abbreviation: "PS", name: "Prior Sanction", description: "Substances for which prior sanction has been granted by FDA for specific uses. There are a number of substances in this category not listed herein because they have not been published in the FEDERAL REGISTER."},
      {abbreviation: "REG", name: "Petition Filed", description: "Food additives for which a petition has been filed and a regulation issued."},
      {abbreviation: "REG/FS", name: "Regualted", description: "Food additives regulated under the FAA and included in a specific food standard."},                                    
    ].each do |reg|
      RegulatoryStatus.create(reg)
    end
  end
  
  desc "Populate Technical Effects"
  task :technical_effects => :environment do
    TechnicalEffect.destroy_all
    
    [ {abbreviation: "AC", name:"Anticaking Agent"},
      {abbreviation: "AF", name:"Antifoaming Agent"},
      {abbreviation: "AOX", name:"Antioxidant"},
      {abbreviation: "BC", name:"Boiler Compound"},
      {abbreviation: "BL", name:"Bleaching Agent/Flour Maturing Agent"},
      {abbreviation: "B&N", name:"Buffer and Neutralizing Agent"},
      {abbreviation: "CTG", name:"Component for Coating Fruits and Vegetables"},
      {abbreviation: "DS", name:"Dietary Supplement"},
      {abbreviation: "EMUL", name:"Emulsifier"},
      {abbreviation: "ENZ", name:"Enzyme"},
      {abbreviation: "ESO", name:"Essential Oil"},
      {abbreviation: "FEED", name:"Substances Added Directly to Feed"},
      {abbreviation: "FLAV", name:"Natural Flavoring Agent"},
      {abbreviation: "FL/ADJ", name:"Subtance Used in Conjunction with Flavors"},
      {abbreviation: "FUM", name:"Fumigant"},
      {abbreviation: "FUNG", name:"Fungicide"},
      {abbreviation: "HERB", name:"Herbicide"},
      {abbreviation: "HOR", name:"Hormone"},
      {abbreviation: "INH", name:"Inhibitor"},
      {abbreviation: "MISC", name:"Miscellaneous"},
      {abbreviation: "NAT", name:"Natural Substance"},
      {abbreviation: "NNS", name:"Non-Nutritive Sweetener"},
      {abbreviation: "NUTR", name:"Nutrient"},
      {abbreviation: "NUTRS", name:"Nutritive Sweetener"},
      {abbreviation: "PEST", name:"Pesticide"},
      {abbreviation: "PRES", name:"Chemical Preservative"},
      {abbreviation: "SANI", name:"Sanitizing Agent"},
      {abbreviation: "SDA", name:"Solubilizing and Dispersing Agent"},
      {abbreviation: "SEQ", name:"Sequestrant"},
      {abbreviation: "SOLV", name:"Sovlent"},
      {abbreviation: "SP", name:"Spices"},
      {abbreviation: "SP/ADJ", name:"Spray Adjuvant"},
      {abbreviation: "STAB", name:"Stabilizer"},
      {abbreviation: "SY/FL", name:"Synthetic Flavor"},
      {abbreviation: "VET", name:"Veterinary Drug"}
    ].each do |te|
      TechnicalEffect.create(te)
    end
  end
  
  desc "Ingredient Descriptions from Wikipedia"
  task :ingredient_descriptions_from_wikipedia => :environment do
    count = Ingredient.count
    current = 1
    
    Ingredient.all.each do |i|
      puts "#{current} of #{count}: #{i.name}"

      begin
        page = Wikipedia.find(Ingredient.all.sample.name)
        @wiki = WikiCloth::Parser.new({:data => page.content})
        html = @wiki.to_html
        plain = ActionView::Base.full_sanitizer.sanitize(html).strip
        plain = CGI.unescapeHTML(plain)
        first_paragraph = plain.split("\n")[0]
      

        if(first_paragraph && first_paragraph.length > 100)
          first_paragraph = first_paragraph.gsub(/[ .,\]]\[[0-9]\]/, "")
          puts first_paragraph
          i.description = first_paragraph
          i.save
        else
          "No Data"
        end
      rescue Exception => e
      end
      
      current += 1
      puts "\n\n"
    end
  end
  
  desc "Populate Ingredients"
  task :ingredients => :environment do
    Label.destroy_all
    Match.destroy_all
    Ingredient.destroy_all

    g_technical_effects = %w(AC AF AOX BC BL B&N CTG DS EMUL ENZ ESO FEED FLAV FL/ADJ FUM FUNG HERB HOR INH MISC NAT NNS NUTR NUTRS PEST PRES SANI SDA SEQ SOLV SP SP/ADJ STAB SY/FL VET)
    g_regulatory_status = %w(BAN FS GRAS GRAS/FS ILL FAA PS PD REG REG/FS)

    file = File.open("#{Rails.root}/doc/fda_additives_dump.txt")
    file.readlines.each do |line|
      name = nil
      technical_effects = []
      regulatory_status = []
      description = ""

      parts = line.split('-').map{|p| p.strip}

      # Parse Name
      name_parts = parts.delete_at(0).split(/[)(,-]/)
      name = name_parts[0]


      info = parts.join(" ")
      if info
        info_parts = info.split(",").map{|p| p.strip}
        info_parts.each do |ip|
          if g_technical_effects.include?(ip)
            technical_effects << ip
          elsif g_regulatory_status.include?(ip)
            regulatory_status << ip
          else
            description += ip
          end
        end
      end

      next if name.nil? || name.length < 4

      ingredient = Ingredient.create({name: name})
      
      ingredient.technical_effects << technical_effects.map{|te| TechnicalEffect.find_by_abbreviation(te)}
      ingredient.regulatory_statuses << regulatory_status.map{|re| RegulatoryStatus.find_by_abbreviation(re)}
      ingredient.save
    end

    ["Ingredients",
     "Contains One Or More Of",
     "Natural And Artificial Flavors",
     "Less Than 2%"
    ].each do |filler|
      Ingredient.create({name: filler})      
    end
  end
  
end