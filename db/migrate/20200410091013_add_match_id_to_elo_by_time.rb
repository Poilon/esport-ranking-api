class AddMatchIdToEloByTime < ActiveRecord::Migration[5.2]
  def change
    add_column :elo_by_times, :match_id, :uuid
  end
end
