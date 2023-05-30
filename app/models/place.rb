class Place < ApplicationRecord
  belongs_to :itinerary
  has_many :events
  has_and_belongs_to_many :interests
  serialize :review_samples, Array
  serialize :opening_hours, Array
end
