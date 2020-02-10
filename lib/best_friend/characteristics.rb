class Characteristic
  
  attr_accessor :name, :stars
  def initialize(hash)
    binding.pry
    self.name = hash.keys[0]
    self.stars = hash[hash.keys[0]]
  end

end
