class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options, id: false do |t|
      t.string :question_id, limit: 36, null: false
      t.text :text_ja, null: false
      t.text :text_en, null: false
      t.integer :order, null: false
      t.integer :filter_type, null: false
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end

    add_index :options, :question_id, name: 'idx_option_question'
    add_foreign_key :options, :questions, column: :question_id, name: 'fk_option_question'
  end
end
