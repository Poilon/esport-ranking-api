class CreateTournament < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments, id: :uuid do |t|
      t.datetime :date
      t.bigint :smashgg_id
      t.string :smashgg_link_url
      t.string :name
      t.integer :weight
      t.uuid :game_id
      t.timestamps
    end
  end
end
