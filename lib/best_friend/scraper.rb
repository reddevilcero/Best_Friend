class Scraper

  def self.group_by(url)
     doc= Nokogiri::HTML(open(url))
    hash = {}
    doc.css('li.item.paws').each do |div| 
      key = div.css('h3').text
      value = div.css('a').attribute('href').value
      hash[key.to_sym] = value
    end
    hash
  end

    def self.breeds_by_url(url)
      doc = Nokogiri::HTML(open(url))
      hash={}
      breeds_list = doc.css('.list-item-title').collect do |breed| 
        hash[breed.text.to_sym] = breed.attribute('href').value
      end
      hash
    end

  def self.all_breeds
    self.breeds_by_url('https://dogtime.com/dog-breeds/profiles/')
   
  end

  def self.group_by_Characteristics
   self.group_by('https://dogtime.com/dog-breeds/characteristics')
  end

  def self.group_by_AKC
    self.group_by('https://dogtime.com/dog-breeds/groups/')
  end

  def self.breed_info(url)
    doc = Nokogiri::HTML(open(url))
    hash = {
      name:doc.css('h1').text,
      bio: doc.css('p').first.text,
      characteristics:[],
      stats: {}
    }
    # Collecting Vital Stats
    doc.css('div.vital-stat-box').collect do |stat|
      stats = stat.text.split(':')
      hash[:stats][stats[0]] = stats[1]
    end
    # Collecting Main Characteristic and Stars Ratings
    doc.css('div.breed-characteristics-ratings-wrapper').collect do |info|
      outer_hash = {}
      key = info.css('div.parent-characteristic').text.strip
      value = info.css('div.parent-characteristic').css('div.star').attribute('class').value[-1].to_i
      outer_hash[key] = value
      hash[:characteristics] << outer_hash
    end
    hash
  end

  def self.create_breed(url)
    info = self.breed_info(url)
    Breed.create_by_hash(info)
  end



end