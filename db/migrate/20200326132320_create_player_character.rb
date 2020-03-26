class CreatePlayerCharacter < ActiveRecord::Migration[5.2]
  def change
    create_table :player_characters, id: :uuid do |t|
      t.uuid :player_id
      t.uuid :character_id
      t.integer :rank
      t.timestamps
    end
  end
end
