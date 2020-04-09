class AddImportedMatchesToTournament < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :imported_matches, :boolean, default: false
  end
end
