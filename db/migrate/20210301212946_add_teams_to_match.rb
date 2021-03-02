class AddTeamsToMatch < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :teams, :boolean
  end
end
