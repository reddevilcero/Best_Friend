require_relative './scraper'

class CLI

   attr_accessor :all_breeds_list, :breeds_by_Characteristics

  def initialize
    @prompt = TTY::Prompt.new
    Async do
      self.scrap_data
    end.wait
    self.start
  end

  def scrap_data
    self.all_breeds_list = Scraper.all_breeds
    self.breeds_by_Characteristics = Scraper.breeds_by_Characteristics
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
    # prompt = TTY::Prompt.new
    input = @prompt.select("select from one of our list or try Doogle search") do |menu|
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
        self.breeds_by_characteristics
      when 3
        self.breeds_by_AKC
      when 4
        self.doogle
      when 5 
        self.exit
    end
  end

  def all_breeds
    # prompt = TTY::Prompt.new
    input = @prompt.yes?("The list of breed is #{self.all_breeds_list.size} do you no prefer use Doogle.")
    if input
      self.doogle
    else
      list = self.all_breeds_list
      input = @prompt.enum_select("Select a breed", list)
      puts input
    end    
  end

  def breeds_by_characteristics
     puts self.breeds_by_Characteristics
    puts "TODO: format in better way"
  end

  def breeds_by_AKC
    puts "TODO: AKC breeds list here"
  end

  def doogle
    # prompt = TTY::Prompt.new
    puts 'Welcome to DOOGLE your breed finder.'
    input = @prompt.ask("Type one or more characters of the desire breed.")
    result = self.all_breeds_list.select{|breed| breed.match(/^#{input}/i)}
    
    if result.size > 1
      result = [@prompt.enum_select("Select a breed", result)]
    end
    sure = @prompt.yes?("Can you confirm '#{result[0]}' is your desire breed?")
    if sure
      puts 'TODO implemente the breed sraper.'
      result[0]
    else
      self.doogle
    end
    
  end

  def exit
    puts "bye Felicia"
  end


  
end