class AddOnlineToTournament < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :online, :boolean
  end
end
