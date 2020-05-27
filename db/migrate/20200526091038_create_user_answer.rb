class CreateUserAnswer < ActiveRecord::Migration[5.2]
  def change
    create_table :user_answers, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :answer_id
      t.boolean :right_answer
      t.bigint :time
      t.timestamps
    end
  end
end
