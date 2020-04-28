class AddPrefixToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :prefix, :string
  end
end
