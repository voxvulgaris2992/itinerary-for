class ChangeInterestsInItineraries < ActiveRecord::Migration[7.0]
  def change
    change_column :itineraries, :interests, :string, array: true, default: [], using: "(string_to_array(interests, ','))"
  end
end
