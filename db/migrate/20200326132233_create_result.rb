class CreateResult < ActiveRecord::Migration[5.2]
  def change
    create_table :results, id: :uuid do |t|
      t.uuid :player_id
      t.uuid :tournament_id
      t.integer :rank
      t.timestamps
    end
  end
end
