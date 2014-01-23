module ApplicationHelper

	def page_title(separator = " | ")
		secondary = content_for(:title).present? ? 
			content_for(:title) : "ingredient database and scanner"

	  ["digestable", secondary].compact.join(separator)
	end

end
