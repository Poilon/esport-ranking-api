class AddHideToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :hide, :boolean
  end
end
