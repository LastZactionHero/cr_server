object @label
attributes :id, :status, :rating
node(:similarity) { |label| label.similarity }

child :matches, :object_root => false do
  attributes :similarity
  child :ingredient do
    attributes :id, :name, :description
  end
end