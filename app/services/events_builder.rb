require 'net/http'
require 'uri'
require 'json'
if Rails.env.development? || Rails.env.test?
  require 'dotenv'
  Dotenv.load
end

class EventsBuilder
  Dotenv.load
  MAPBOX_API_KEY = ENV['MAPBOX_API_KEY']

  def initialize(itinerary)
    @itinerary = itinerary
  end

  def build
    all_places = []
    @itinerary.interests.each do |interest|
      interest_record = Interest.find_by(name: interest)
      places = Place.joins(:interests).where(interests: { id: interest_record.id }, itinerary_id: @itinerary.id)
      all_places << places
    end
    # Select the top place for each interest
    selected_places = all_places.map(&:first).compact
    # Return the all_places flattened into one array and selected_places arrays
    [all_places.flatten, selected_places]
  end
end
