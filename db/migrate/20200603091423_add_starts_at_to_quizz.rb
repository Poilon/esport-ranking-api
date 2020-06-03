class AddStartsAtToQuizz < ActiveRecord::Migration[5.2]
  def change
    add_column :quizzs, :starts_at, :bigint
  end
end
