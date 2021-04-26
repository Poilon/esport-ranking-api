class ChangePlayerSmashggIdToString < ActiveRecord::Migration[6.0]
  def change
    change_column :players, :smashgg_id, :string
  end
end
