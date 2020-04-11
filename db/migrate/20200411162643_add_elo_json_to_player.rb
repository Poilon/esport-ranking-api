class AddEloJsonToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :elo_json, :string
  end
end
