class Breed

  @@all = []
  attr_accessor :name, :bio, :characteristics, :stats, :url

  def self.instance_by_hash(hash)
    hash.each  do |key, value|
      Breed.new.tap do |breed|
        breed.name = key
        breed.url = value
        breed.save
      end
    end
   
  end

  def self.find_by_regex(input)
    result = self.all.select {|ins| ins.name.match(/^#{input}/i)}
    
    if !result.empty?
      binding.pry
      self.to_one_result(result)
    else
      self.not_found(input)
    end
  end

  def self.to_one_result(array)
    if array.size > 1
      hash = TTY::Prompt.new.enum_select("Select a breed", hash, per_page: 10)
      breed_name = self.hash.key(hash)
      url = self.hash[breed_name]
    else
      breed_name = array[0].name
      url = array[0].url
    end
    return breed_name, url
  end
  
  def self.not_found(input)
    again =TTY::Prompt.new.yes?("Sorry but '#{input}'' does not match any know breed name. do you want to try again?")
    if again
      self.find_by_regex(input)
    end
  end

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