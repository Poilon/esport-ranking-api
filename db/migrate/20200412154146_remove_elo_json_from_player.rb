class RemoveEloJsonFromPlayer < ActiveRecord::Migration[6.0]
  def change

    remove_column :players, :elo_json, :string
  end
end
