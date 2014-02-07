collection @ingredients
attributes :id, :name

node(:subtitle){|i|
	i.technical_effects_string
}