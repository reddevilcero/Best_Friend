class Doogle

  attr_reader :hash, :breed

  def search(hash)
    @hash = hash
    input = self.ask_for_input
    self.result(input)
    self.breed
  end

  def ask_for_input
    input = TTY::Prompt.new.ask("Type one or more characters of the desire breed.") do |q|
          q.validate /[a-zA-Z]/
        end
    input
  end

  def result(input)
    result = self.hash.select{|breed| breed.match(/^#{input}/i)}
    if !result.empty?
      breed_name, url = self.to_one_result(result)
      self.right_breed(breed_name, url)
    else
      self.not_found(input)
    end
  end

  def right_breed(breed, url)
    sure = TTY::Prompt.new.yes?("Can you confirm '#{breed}' is your desire breed?")
    if sure
      breed_object =Scraper.create_breed(url)
      @breed = breed_object
    else
      self.search(self.hash)
    end
  end

  def to_one_result(hash)
    if hash.size > 1
      hash = TTY::Prompt.new.enum_select("Select a breed", hash, per_page: 10)
      breed_name = self.hash.key(hash)
      url = self.hash[breed_name]
    else
      breed_name = hash.keys[0]
      url = hash.values[0]
    end
    return breed_name, url
  end

  def not_found(input)
    again =TTY::Prompt.new.yes?("Sorry but '#{input}'' does not match any know breed name. do you want to try again?")
    if again
      self.search(self.hash)
    end
  end


end