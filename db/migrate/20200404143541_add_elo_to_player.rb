class AddEloToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :elo, :integer
  end
end
