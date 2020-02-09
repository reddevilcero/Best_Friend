require_relative './scraper'

class CLI

   attr_accessor :all_breeds_list, :breeds_by_Characteristics

   def initialize
    Async do
      self.scrap_data
    end.wait
    puts 'scrapping'
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
    prompt = TTY::Prompt.new
    input = prompt.select("select from one of our list or try Doogle search") do |menu|
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
    prompt = TTY::Prompt.new
    input =prompt.yes?("The list of breed is #{self.all_breeds_list.size} do you no prefer use Doogle.")
    if input
      self.doogle
    else
      self.all_breeds_list.each_with_index do |breed, index|
        puts "#{index + 1}. #{breed}"
        #find if prompt can do this better?
      end
      puts 'Todo ask for dog name or number? not sure'
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
    puts 'TODO implement the search method'
  end

  def exit
    puts "bye Felicia"
  end


  
end