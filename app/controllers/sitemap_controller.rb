class SitemapController < ApplicationController

	def sitemap
		@ingredients = Ingredient.visible
	end

end