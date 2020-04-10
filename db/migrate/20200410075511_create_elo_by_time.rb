class CreateEloByTime < ActiveRecord::Migration[5.2]
  def change
    create_table :elo_by_times, id: :uuid do |t|
      t.datetime :date
      t.uuid :player_id
      t.integer :elo
      t.timestamps
    end
  end
end
