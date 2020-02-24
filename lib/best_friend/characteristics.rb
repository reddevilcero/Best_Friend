class Characteristic

  attr_accessor :name, :stars
  
  def new_from_hash(hash)
    self.name = hash.keys[0]
    self.stars = hash[hash.keys[0]]

  end

end
