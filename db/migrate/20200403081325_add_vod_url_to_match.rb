class AddVodUrlToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :vod_url, :string
  end
end
