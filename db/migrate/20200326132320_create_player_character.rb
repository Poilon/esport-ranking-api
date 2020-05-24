class CreatePlayerCharacter < ActiveRecord::Migration[5.2]
  def change
    create_table :player_characters, id: :uuid do |t|
      t.player :blongs_to
      t.uuid :character_id
      t.integer :rank
      t.timestamps
    end
  end
end
