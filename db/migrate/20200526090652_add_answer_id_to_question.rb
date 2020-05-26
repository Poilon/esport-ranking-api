class AddAnswerIdToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :answer_id, :uuid
  end
end
