class AddPlayedToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :played, :boolean
  end
end
