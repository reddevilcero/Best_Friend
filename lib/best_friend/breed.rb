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
      end
      breed.add_stats(breed.stats)
      breed.add_charac(breed.characteristics)
      breed.save
      binding.pry
    end
 
  end

  def add_stats(hash)
    self.stats =Stats.new(hash)
  end
  def add_charac(array)
    self.characteristics = []
    array.each do|charac|
      self.characteristics << Characteristic.new(charac)
    end
  end
 
 
end