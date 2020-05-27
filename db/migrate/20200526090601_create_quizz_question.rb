class CreateQuizzQuestion < ActiveRecord::Migration[5.2]
  def change
    create_table :quizz_questions, id: :uuid do |t|
      t.uuid :quizz_id
      t.uuid :question_id
      t.timestamps
    end
  end
end
