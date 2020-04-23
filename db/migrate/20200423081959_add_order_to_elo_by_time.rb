class AddOrderToEloByTime < ActiveRecord::Migration[5.2]
  def change
    add_column :elo_by_times, :order, :integer
  end
end
