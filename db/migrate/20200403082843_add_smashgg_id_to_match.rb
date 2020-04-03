class AddSmashggIdToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :smashgg_id, :bigint
  end
end
