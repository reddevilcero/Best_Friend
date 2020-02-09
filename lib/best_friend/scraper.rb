# require 'open-uri'
class Scraper

  def self.group_by(url)
     doc= Nokogiri::HTML(open(url))
    hash = {}
    doc.css('li.item.paws').collect do |div| 
      key = div.css('h3').text
      value = div.css('a').attribute('href').value
      hash[key.to_sym] = value
    end
    hash
  end

    def self.breeds_by_url(url)
    doc = Nokogiri::HTML(open(url))
    breeds_list = doc.css('.list-item-title').collect{|breed| breed.text}    
  end

  def self.all_breeds
    self.group_by('https://dogtime.com/dog-breeds')
  end

  def self.group_by_Characteristics
   self.group_by('https://dogtime.com/dog-breeds/characteristics')
  end

  def self.group_by_AKC
    self.group_by('https://dogtime.com/dog-breeds/groups/')
  end




end