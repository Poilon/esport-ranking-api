class AddProfilePictureUrlToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :profile_picture_url, :string
  end
end
