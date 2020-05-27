class CreateAnswer < ActiveRecord::Migration[5.2]
  def change
    create_table :answers, id: :uuid do |t|
      t.string :name
      t.uuid :question_id
      t.timestamps
    end
  end
end
