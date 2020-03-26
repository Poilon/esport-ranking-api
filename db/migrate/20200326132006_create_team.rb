class CreateTeam < ActiveRecord::Migration[5.2]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.string :prefix
      t.string :slug
      t.timestamps
    end
  end
end
