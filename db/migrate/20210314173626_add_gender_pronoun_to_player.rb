class AddGenderPronounToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :gender_pronoun, :string
  end
end
