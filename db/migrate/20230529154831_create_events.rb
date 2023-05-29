class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :itinerary, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.integer :counter
      t.text :directions

      t.timestamps
    end
  end
end
