class AddTwitchSteamDiscordMixerToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :twitch, :string
    add_column :players, :steam, :string
    add_column :players, :discord, :string
    add_column :players, :mixer, :string
  end
end
