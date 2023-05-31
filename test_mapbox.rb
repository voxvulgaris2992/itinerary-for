# test_mapbox.rb

require 'net/http'
require 'uri'
require 'json'

require 'dotenv'
Dotenv.load

MAPBOX_API_KEY = ENV['MAPBOX_API_KEY']

selected_places = [{longitude: -122.45, latitude: 37.91}, {longitude: -122.48, latitude: 37.73}]
itinerary = {longitude: -122.42, latitude: 37.78}

coordinates = selected_places.map { |place| "#{place[:longitude]},#{place[:latitude]}" }
coordinates.unshift("#{itinerary[:longitude]},#{itinerary[:latitude]}")

uri = URI.parse("https://api.mapbox.com/optimized-trips/v1/mapbox/walking/#{coordinates.join(';')}?access_token=#{ENV['MAPBOX_API_KEY']}")

response = Net::HTTP.get_response(uri)

if response.is_a?(Net::HTTPSuccess)
  data = JSON.parse(response.body)
  waypoints = data['waypoints'].map { |waypoint| waypoint['location'] }
  puts "Waypoints: #{waypoints.inspect}"
else
  puts "Mapbox API Key: #{MAPBOX_API_KEY}"
  puts "HTTP request failed with status code: #{response.code}"
  puts "Waypoints: #{waypoints.inspect}"
end
