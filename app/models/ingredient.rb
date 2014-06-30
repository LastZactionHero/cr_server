class Ingredient < ActiveRecord::Base
  attr_accessible :description, :name, :bulk_description, :visible, :proofed,
    :view_count

  has_many :matches
  has_many :labels, :through => :matches
  has_and_belongs_to_many :technical_effects
  has_and_belongs_to_many :regulatory_statuses
  has_and_belongs_to_many :resources
  validates_uniqueness_of :name

  #default_scope order("name ASC")
  scope :visible, -> { where(visible: true) }
  scope :not_proofed, -> { where(proofed: false) }
  scope :most_popular, -> { order("view_count DESC") }

  def self.name_list
    Ingredient.pluck(:name)
  end

  def to_s
    name
  end

  def technical_effects_string
    technical_effects.map{|te| te.name}.join(", ")
  end

  def path
    "/#{URI::encode(name)}"
  end

  def proofed!
    self.proofed = true
    save
  end

  def increment_view_count!
    self.view_count += 1
    self.save
  end

  def related
    related_ingredients = []

    related_ingredients << technical_effects.map do |te|
      te.ingredients.most_popular.limit(10)
    end

    related_ingredients.flatten!
    related_ingredients.delete(self)
    related_ingredients.uniq
  end

end
