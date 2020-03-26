class CreatePlayer < ActiveRecord::Migration[5.2]
  def change
    create_table :players, id: :uuid do |t|
      t.bigint :smashgg_id
      t.string :name
      t.string :location
      t.string :city
      t.string :sub_state
      t.string :state
      t.string :country
      t.float :latitude
      t.float :longitude
      t.string :twitter
      t.string :youtube
      t.string :wiki
      t.integer :score
      t.timestamps
    end
  end
end
