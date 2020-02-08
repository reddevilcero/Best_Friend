require 'open-uri'
class Scraper

  def self.all_breeds
    doc = Nokogiri::HTML(open('https://dogtime.com/dog-breeds'))
    breeds = doc.css('ul.search-results-list li')
    breeds_list = breeds.collect{|breed| breed.css('a').text}
  end


end