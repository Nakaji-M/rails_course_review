class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers, id: false do |t|
      t.string :form_token, limit: 255, null: false
      t.string :course_id, limit: 36, null: false
      t.string :question_id, limit: 36, null: false
      t.text :content, null: false
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end

    add_index :answers, [:form_token, :course_id, :question_id], unique: true, name: 'uniq_answer_token_course_question'
    add_index :answers, :course_id, name: 'idx_answer_course'
    add_index :answers, :question_id, name: 'idx_answer_question'
    add_foreign_key :answers, :courses, column: :course_id, name: 'fk_answer_course'
    add_foreign_key :answers, :questions, column: :question_id, name: 'fk_answer_question'
  end
end
