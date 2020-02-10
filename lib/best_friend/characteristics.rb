class Characteristic

  attr_accessor :name, :info

  def initialize(hash)
    binding.pry
    @name = hash.keys[0]
    @info = hash[hash.keys[0]]
  end

end
