class CLI

  def pastel
    Pastel.new
  end

  def prompt
    TTY::Prompt.new
  end

  def start
    puts self.welcome
    Scraper.all_breeds
    self.menu
    
  end


  def welcome
    system 'clear'
    a = Artii::Base.new :font => 'colossal'
    logo = a.asciify('Best Friend')
    logo = self.pastel.green(logo)
    a = Artii::Base.new :font => 'digital'
   
    heading = a.asciify('CLI Project for Flatiron School.')
    heading = self.pastel.decorate(heading, :cyan, :bold)
    
    <<~Logo
      #{logo}
      #{heading}
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

  def doogle(hash)
    puts Doogle.new.doogle_logo
    object= Doogle.new.search(hash)
    if object
    self.display_info(object)
    else
      self.exit
    end
  end

  def all_breeds
    all_breeds_list = Breed.all.collect{|i| i.name}
    input = self.prompt.yes?("The list of breed is #{all_breeds_list.size} do you no prefer use Doogle.")
    if input
      puts Doogle.new.doogle_logo
      object= Doogle.new.search(all_breeds_list)
      self.display_info(object)
    else
      input = self.prompt.enum_select("Select a breed", all_breeds_list, per_page: 10)
      url = Breed.find_by_regex(input)
      breed_object= Scraper.create_breed(url)
      self.display_info(breed_object)
    end   
  end

  def group_by(hash) 
    choices = hash.keys
    input = self.prompt.enum_select("Select a Group", choices, per_page: 10)
    puts self.welcome
    breeds = Scraper.breeds_by_url(hash[input]) #send the link to breeds_by and return a hash
    if breeds.size > 50
      input = self.prompt.yes?("The list of breeds is #{breeds.size} do you rather use Doogle?")
      if input
        self.doogle(breeds)
      else
       self.display_selected(breeds)
      end
    else
      self.display_selected(breeds)
    end
  end

  def display_selected(hash)
    selected_breed_url = self.prompt.enum_select("Select a Group", hash, per_page: 10)
    breed_object = Scraper.create_breed(selected_breed_url)
    self.display_info(breed_object)
  end


  def group_by_characteristics
    self.group_by(Scraper.group_by_Characteristics)
  end

  def breeds_by_AKC
    self.group_by(Scraper.group_by_AKC)
  end

  def display_info(object)
    system 'clear'
    puts self.welcome

    ############### Breed Name ###############
    name = self.display_name(object.name)
    ############### Table for Bio #############
    bio_table = self.display_bio(object.bio)
    ############### Table for characteristic #####################
    c_table = self.display_charac(object.characteristics)
    ############### Table for Vital Stats ##################
    vital_table = self.display_vital(object)
    ############### Final output #####################
    puts <<~Info
    #{name} 
    #{bio_table}
    #{c_table}
    ==========================================================================================================
    #{vital_table}
    Info
    self.continue
  end

  def display_name(str)
    name = self.create_art(str, 'slant')
    name = self.pastel.decorate(name, :bright_blue)
  end
  def create_art(str, fonttype)
    artii = Artii::Base.new :font => fonttype
    artii.asciify(str)
  end

  def display_bio(str)
    bio = self.create_art('BIO', 'smslant')
    bio = self.pastel.decorate(bio, :cyan)
    bio_table = Terminal::Table.new :title => bio
    str = self.fit_in_table(str)
    bio_table << [str]
    bio_table.style = {:width => 105}
    bio_table
  end

  def display_charac(array)
    c_table = Terminal::Table.new do |t|
      array.each do|c| 
        t.add_row [c.name, self.pastel.bright_yellow('*'* c.stars + self.pastel.white('*'*(5-c.stars)))]
      end
    end
    c_table.style = {:all_separators => true,:alignment => :center}
    title =  self.create_art('Main characteristics', 'smslant')
    title = self.pastel.cyan(title)
    c_table.title = title
    c_table
  end

  def display_vital(object)
    row = [[object.stats.dog_breed_group, object.stats.height, object.stats.weight , object.stats.life_span]]
    headings = ['Dog Breed Group:', 'Height:', 'Weight:', 'Life Span']
    vital_table = Terminal::Table.new :headings => headings, :rows => row
    vital_table.style = {:alignment => :center}
    title = self.create_art('Vital Stats', 'smslant')
    title = self.pastel.cyan(title)
    vital_table.title = title
    vital_table
  end

  def fit_in_table(str)
    new_str= str.chars.each_slice(100).map(&:join)
    new_str.join("\n")
  end

  def continue
    more = self.prompt.yes?("Do You want to find other breed?")
    if more
      self.menu
    else
      self.exit
    end
  end

  def exit
    goodbye = self.create_art('Thanks for use Best Friend', 'slant')
    goodbye = self.pastel.decorate(goodbye, :cyan, :bold)
    puts goodbye
    sleep(3)
    system 'clear'
  end

  
end