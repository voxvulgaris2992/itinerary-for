class CreateItineraries < ActiveRecord::Migration[7.0]
  def change
    create_table :itineraries do |t|
      t.text :address
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :budget
      t.text :interests

      t.timestamps
    end
  end
end
