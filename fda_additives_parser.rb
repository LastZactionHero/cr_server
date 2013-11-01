g_technical_effects = %w(AC AF AOX BC BL B&N CTG DS EMUL ENZ ESO FEED FLAV FL/ADJ FUM FUNG HERB HOR INH MISC NAT NNS NUTR NUTRS PEST PRES SANI SDA SEQ SOLV SP SP/ADJ STAB SY/FL VET)
g_regulatory_status = %w(BAN FS GRAS FD%C ILL FAA PS PD REG)

file = File.open("fda_additives_dump.txt")
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
    info_parts = info.split(",").map{|p| p.strip.split("/")}.flatten
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
  
  # if info
  #     info_parts = info.split(",").map{|i| i.strip}
  #   
  #     description = info_parts.last
  #     puts description
  #   end
  #   
  next if name.nil? || name.length < 4
  
  puts "#{name} - #{technical_effects} - #{regulatory_status}"
end
