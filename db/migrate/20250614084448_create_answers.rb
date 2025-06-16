class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers, id: :string, limit: 36 do |t|
      t.references :question, type: :string, limit: 36, null: false, foreign_key: true, index: false
      t.string :form_token, limit: 255, null: false
      t.integer :ocw_id, null: false
      t.text :content, null: false
      t.timestamps
    end

    add_index :answers, :ocw_id, name: 'idx_answer_ocw_id'
    add_index :answers, [:form_token, :ocw_id, :question_id], unique: true, name: 'uniq_answer_token_ocw_question'
  end
end
