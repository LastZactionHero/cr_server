xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "http://digestable.co"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "http://digestable.co/ingredients"
    xml.priority 1.0
  end

  @ingredients.each do |ingredient|
    xml.url do
      xml.loc "http://digestable.co/#{u ingredient.name}"
      xml.priority 0.9
    end
  end

end