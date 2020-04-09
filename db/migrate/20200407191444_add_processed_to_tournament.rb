class AddProcessedToTournament < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :processed, :boolean, default: false
  end
end
