require 'net/http'
require 'uri'
require 'json'

class GooglePlacesApi
  BASE_URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'.freeze

  INTEREST_TO_TYPE_MAPPING = {
    'History' => ['museum', 'church', 'hindu_temple', 'mosque', 'synagogue'],
    'Art & Culture' => ['art_gallery', 'museum', 'library'],
    'Dining' => ['restaurant', 'cafe', 'bakery'],
    'Drinks' => ['bar', 'night_club'],
    'Activity' => ['amusement_park', 'bowling_alley', 'gym', 'spa', 'zoo', 'stadium'],
    'Shopping' => ['clothing_store', 'department_store', 'electronics_store', 'shopping_mall', 'supermarket'],
    'Outdoors' => ['park', 'campground', 'rv_park'],
    'Attraction' => ['tourist_attraction', 'aquarium', 'zoo', 'stadium', 'amusement_park']
  }.freeze

  def initialize(itinerary)
    @itinerary = itinerary
  end

  def get_places
    places = []

    @itinerary.interests.each do |interest|
      INTEREST_TO_TYPE_MAPPING[interest].each do |type|
        results = make_request(type)

        # Add a debugging print statement here
        puts "Results for #{interest} (#{type}): #{results}"

        places.concat(results['results']) if results['results']
      end
    end

    places
  end

  private

  PRICE_LEVEL_TYPES = ['restaurant', 'cafe', 'bar', 'night_club'].freeze

  def make_request(type)
    url = "#{BASE_URL}?location=#{@itinerary.latitude},#{@itinerary.longitude}&radius=1500&type=#{type}"
    url += "&minprice=#{@itinerary.budget - 1}&maxprice=#{@itinerary.budget}" if PRICE_LEVEL_TYPES.include?(type)
    url += "&key=#{ENV['GOOGLE_API_KEY']}"

    uri = URI(url)
    puts "Constructed URL: #{uri}"
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
