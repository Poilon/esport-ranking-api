class CreatePlayerTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :player_teams, id: :uuid do |t|
      t.uuid :player_id
      t.uuid :team_id

      t.timestamps
    end
  end
end
