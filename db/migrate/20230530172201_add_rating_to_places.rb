class AddRatingToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :rating, :float
  end
end
