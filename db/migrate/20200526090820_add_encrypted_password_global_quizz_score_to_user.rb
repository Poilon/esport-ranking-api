class AddEncryptedPasswordGlobalQuizzScoreToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_password, :string
    add_column :users, :global_quizz_score, :integer
  end
end
