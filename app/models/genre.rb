class Genre < ActiveRecord::Base
  has_many :song_genres
  has_many :songs, through: :song_genres
  has_many :artists, through: :songs

  def slug
    self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    unslug = slug.gsub("-", " ")
    self.all.where("name LIKE ?", "%#{unslug}%")[0]
  end
  end
