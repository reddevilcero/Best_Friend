require_relative './scraper'

class CLI

   attr_accessor :all_breeds_list, :group_by_Characteristics, :breeds_by_group

  def initialize
    Async do
      self.scrap_data
    end.wait
    self.start
  end

  def prompt
    TTY::Prompt.new
  end

  def scrap_data
    self.all_breeds_list = Scraper.all_breeds
    self.group_by_Characteristics = Scraper.group_by_Characteristics
    self.breeds_by_group = Scraper.group_by_AKC
    puts 'no finish yet'
  end


  def start
    puts self.welcome
    self.menu
  end

  def welcome
  <<-Logo
      TODO: here it will be place a fancy logo
      or something close.

    Logo
  end

  def menu
    input = self.prompt.select("select from one of our list or try Doogle search") do |menu|
      menu.choice name: 'All Breeds', value: 1
      menu.choice name: 'Breeds Group by Characteristics', value: 2
      menu.choice name: 'Breeds Group by Using AKC Categories', value: 3
      menu.choice name: 'Doogle search', value: 4
      menu.choice name: 'Exit', value: 5
    end

    case input
      when 1
        self.all_breeds
      when 2
        self.group_by_characteristics
      when 3
        self.breeds_by_AKC
      when 4
        self.doogle(self.all_breeds_list)
      when 5 
        self.exit
    end
  end

  def all_breeds
    input = self.prompt.yes?("The list of breed is #{self.all_breeds_list.size} do you no prefer use Doogle.")
    if input
      self.doogle
    else
      list = self.all_breeds_list
      url = self.prompt.enum_select("Select a breed", list, per_page: 10)
      Scraper.breed_info(url)
    end    
  end

  def group_by(hash) #use_doogle=true
    choices = hash.keys
    input = self.prompt.enum_select("Select a Group", choices, per_page: 10)
    breeds = Scraper.breeds_by_url(hash[input]) #send the link to breeds_by an return a hash
    selected_breed_url = self.prompt.enum_select("Select a Group", breeds, per_page: 10)
    Scraper.breed_info(selected_breed_url)
    puts "TODO: format in better way"
  
  end

  def group_by_characteristics
    self.group_by(self.group_by_Characteristics)
  end

  def breeds_by_AKC
    self.group_by(self.breeds_by_group)
  end

  def doogle(hash)
    puts 'Welcome to DOOGLE your breed finder.'
    input = self.prompt.ask("Type one or more characters of the desire breed.") do |q|
      q.validate /[a-zA-Z]/
    end
    result = hash.select{|breed| breed.match(/^#{input}/i)}
    
    if !result.empty?
      if result.size > 1
        result = self.prompt.enum_select("Select a breed", result, per_page: 10)
        dog_name = all_breeds_list.key(result)
        url = all_breeds_list[dog_name]
      else
        dog_name = result.keys[0]
        url = result.values[0]
      end
      
      sure = self.prompt.yes?("Can you confirm '#{dog_name}' is your desire breed?")
      if sure
        Scraper.breed_info(url)
      else
        self.doogle(hash)
      end
    else
       again =self.prompt.yes?("Sorry but '#{input}'' does not match any know breed name. do you want to try again?")
      if again
        self.doogle(hash)
      else
          self.menu
      end
        
    end
 
    
  end

  def exit
    puts "bye Felicia"
  end


  
end