class AddGifUrlToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :gif_url, :string
  end
end
