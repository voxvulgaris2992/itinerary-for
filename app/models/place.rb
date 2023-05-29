class Place < ApplicationRecord
  belongs_to :itinerary
  has_many :events
end
