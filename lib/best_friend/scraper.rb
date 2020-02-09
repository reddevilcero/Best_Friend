# require 'open-uri'
class Scraper

  def self.all_breeds
    doc = Nokogiri::HTML(open('https://dogtime.com/dog-breeds'))
    breeds_list = doc.css('ul.search-results-list li').collect{|breed| breed.css('a').text}
  end

  def self.breeds_by_Characteristics
    doc= Nokogiri::HTML(open('https://dogtime.com/dog-breeds/characteristics'))
    charac_list = doc.css('h3.callout-heading').collect{|charac| charac.text}

  end


end