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
      return array[0]
    end
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

  def self.update_by_hash(hash, object)

    hash.each do |key, value| 
      object.send("#{key}=", value)
    end
    object.add_stats(object.stats)
    object.add_charac(object.characteristics)
    object.save
    object
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

  def doogle_logo
    p = Pastel.new
    <<-logo
                        Welcome                          
                          to                             
    .#{p.blue'%%%%%'}....#{p.red('%%%%')}....#{p.yellow('%%%%')}....#{p.blue('%%%%')}...#{p.green('%%')}......#{p.red('%%%%%%')}.
    .#{p.blue('%%')}..#{p.blue('%%')}..#{p.red('%%')}..#{p.red('%%')}..#{p.yellow('%%')}..#{p.yellow('%%')}..#{p.blue('%%')}......#{p.green('%%')}......#{p.red('%%')}..... 
    .#{p.blue('%%')}..#{p.blue('%%')}..#{p.red('%%')}..#{p.red('%%')}..#{p.yellow('%%')}..#{p.yellow('%%')}..#{p.blue('%%')}.#{p.blue('%%%')}..#{p.green('%%')}......#{p.red('%%%%')}... 
    .#{p.blue('%%')}..#{p.blue('%%')}..#{p.red('%%')}..#{p.red('%%')}..#{p.yellow('%%')}..#{p.yellow('%%')}..#{p.blue('%%')}..#{p.blue('%%')}..#{p.green('%%')}......#{p.red('%%')}..... 
    .#{p.blue('%%%%%')}....#{p.red('%%%%')}....#{p.yellow('%%%%')}....#{p.blue('%%%%')}...#{p.green('%%%%%%')}..#{p.red('%%%%%%')}. 
    #{p.cyan'................................................'} 
    
    logo
  end
 
 
end