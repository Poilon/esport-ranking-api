class CreateGame < ActiveRecord::Migration[5.2]
  def change
    create_table :games, id: :uuid do |t|
      t.bigint :smashgg_id
      t.string :name
      t.string :slug
      t.timestamps
    end
  end
end
