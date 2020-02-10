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
      hash.each{|key, value| 
        breed.send("#{key}=", value)}
      breed.save
    end
   binding.pry
  end
 
 
end