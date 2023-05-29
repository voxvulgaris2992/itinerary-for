class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.text :name
      t.text :description
      t.text :address
      t.text :opening_hours
      t.text :phone
      t.text :map_static
      t.text :map_link
      t.text :review_count
      t.text :review_samples

      t.timestamps
    end
  end
end
