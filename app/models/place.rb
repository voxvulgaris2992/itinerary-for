class Place < ApplicationRecord
  belongs_to :itinerary
  has_many :events
  serialize :review_samples, Array
  serialize :opening_hours, Array
end
