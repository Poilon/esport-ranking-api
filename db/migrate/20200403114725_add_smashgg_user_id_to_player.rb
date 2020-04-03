class AddSmashggUserIdToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :smashgg_user_id, :bigint
  end
end
