class CreateCharacter < ActiveRecord::Migration[5.2]
  def change
    create_table :characters, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.uuid :game_id
      t.timestamps
    end
  end
end
