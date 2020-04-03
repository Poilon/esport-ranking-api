class CreateMatch < ActiveRecord::Migration[5.2]
  def change
    create_table :matches, id: :uuid do |t|
      t.uuid :winner_player_id
      t.uuid :loser_player_id
      t.uuid :tournament_id
      t.timestamps
    end
  end
end
