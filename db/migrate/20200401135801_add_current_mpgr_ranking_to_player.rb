class AddCurrentMpgrRankingToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :current_mpgr_ranking, :integer
  end
end
