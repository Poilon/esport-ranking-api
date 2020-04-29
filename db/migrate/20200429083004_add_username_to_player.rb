class AddUsernameToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :username, :string
  end
end
