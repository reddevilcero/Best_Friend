class Breed

  @@all = []
  attr_accessor :name, :bio, :characteristics, :stats

  def self.all
      @@all
  end

  def save
    @@all << self
  end

  def self.create_by_hash(hash)
    Breed.new.tap do |breed| 
      hash.each do |key, value| 
        breed.send("#{key}=", value)
        breed.add_stats(hash[:stats])
      end
      breed.save
    end
 
  end

  def add_stats(hash)
    self.stats =Stats.new(hash)
  end
 
 
end