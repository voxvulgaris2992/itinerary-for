class CreateJoinTablePlaceInterest < ActiveRecord::Migration[7.0]
  def change
    create_join_table :places, :interests do |t|
      # t.index [:place_id, :interest_id]
      # t.index [:interest_id, :place_id]
    end
  end
end
