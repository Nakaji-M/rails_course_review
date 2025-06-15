class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers, id: :string, limit: 36 do |t|
      t.references :course, type: :string, limit: 36, null: false, foreign_key: true, index: { name: 'idx_answer_course' }
      t.references :question, type: :string, limit: 36, null: false, foreign_key: true, index: false
      t.string :form_token, limit: 255, null: false
      t.text :content, null: false
      t.timestamps
    end

    add_index :answers, [:form_token, :course_id, :question_id], unique: true, name: 'uniq_answer_token_course_question'
  end
end
