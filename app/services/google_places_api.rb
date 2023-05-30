require 'net/http'
require 'uri'
require 'json'
require 'phony'

class GooglePlacesApi
  BASE_URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'.freeze
  DETAILS_URL = 'https://maps.googleapis.com/maps/api/place/details/json'.freeze

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
    @itinerary.interests.each do |interest|
      INTEREST_TO_TYPE_MAPPING[interest].each do |type|
        results = make_request(type)

        puts "Results for #{interest} (#{type}): #{results}"

        results['results'].each do |result|
          place = {
            name: result['name'],
            address: result['vicinity'],
            rating: result['rating'],
            description: result['url'], # using URL as the description
            google_place_id: result['place_id'],
            itinerary_id: @itinerary.id # associate the place with the current itinerary
          }

          details = get_place_details(place[:google_place_id])
          place.merge!(details)
          place.delete(:google_place_id)
          place.delete(:formatted_address)
          place[:address] = details[:formatted_address]
          place[:review_count] = place[:review_count].to_s
          place[:review_samples] = place[:review_samples] || [] # Make sure review_samples is an array
          place[:opening_hours] = place[:opening_hours] || [] # Make sure opening_hours is an array

          # Find or create the Interest
          interest_record = Interest.find_or_create_by(name: interest)
          # Build the new Place record and associate the Interest
          place_record = Place.new(place.merge(itinerary: @itinerary))
          place_record.interests << interest_record
          place_record.save
        end if results['results']
      end
    end
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

  def get_place_details(place_id)
    url = "#{DETAILS_URL}?place_id=#{place_id}&key=#{ENV['GOOGLE_API_KEY']}"
    uri = URI(url)
    puts "Constructed Details URL: #{uri}"
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)['result']

    # Get the first four reviews if available
    review_samples = result['reviews'].take(4).map { |review| review['text'] } if result['reviews']

    # Get the first image if available
    image_url = nil
    if result['photos']
      photo_reference = result['photos'][0]['photo_reference']
      image_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLE_API_KEY']}"
    end

    details = {
      formatted_address: result['formatted_address'],
      opening_hours: result['opening_hours']['weekday_text'],
      phone: format_phone_number(result['formatted_phone_number']),
      description: result['website'],
      map_link: "https://www.google.com/maps/place/?q=place_id:#{place_id}",
      map_static: "https://maps.googleapis.com/maps/api/staticmap?center=#{result['geometry']['location']['lat']},#{result['geometry']['location']['lng']}&zoom=14&size=400x400&key=#{ENV['GOOGLE_API_KEY']}",
      review_count: result['user_ratings_total'],
      review_samples: review_samples,
      image: image_url
    }

    details
  rescue
    puts "Failed to get details for place_id: #{place_id}"
    {}
  end

  def format_phone_number(number)
    normalized_number = Phony.normalize(number)
    Phony.formatted(normalized_number, format: :international)
  end
end
