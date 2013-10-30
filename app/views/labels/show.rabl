object @label
attributes :id, :status, :rating
node(:similarity) { |label| label.similarity }

child :matches do
  attributes :similarity
  child :ingredient do
    attributes :name, :description
  end
end