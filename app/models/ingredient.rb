class Ingredient < ActiveRecord::Base
  attr_accessible :description, :name, :bulk_description, :visible, :proofed
  
  has_many :matches
  has_many :labels, :through => :matches
  has_and_belongs_to_many :technical_effects
  has_and_belongs_to_many :regulatory_statuses
  
  validates_uniqueness_of :name
  
  default_scope order("name ASC")
  scope :visible, -> { where(visible: true) }
  scope :not_proofed, -> { where(proofed: false)}
  
  def self.name_list
    Ingredient.pluck(:name)
  end
  
  def to_s
    name
  end
  
  def path
    "/#{URI::encode(name)}"
  end

  def proofed!
    self.proofed = true
    save
  end
  
end
