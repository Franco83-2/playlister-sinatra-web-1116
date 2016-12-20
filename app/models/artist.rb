class Artist < ActiveRecord::Base
  has_many :songs
  has_many :genres, through: :songs

  def slug
    self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    unslug = slug.gsub("-", " ")
    self.all.where("name LIKE ?", "%#{unslug}%")[0]
  end

end
