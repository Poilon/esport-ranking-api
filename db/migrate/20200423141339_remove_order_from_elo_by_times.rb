class RemoveOrderFromEloByTimes < ActiveRecord::Migration[6.0]
  def change

    remove_column :elo_by_times, :order, :integer
  end
end
