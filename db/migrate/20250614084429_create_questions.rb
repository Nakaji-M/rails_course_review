class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions, id: false do |t|
      t.string :id, limit: 36, null: false, primary_key: true, default: -> { 'UUID()' }
      t.text :text_ja, null: false
      t.text :text_en, null: false
      t.text :description_ja, null: false
      t.text :description_en, null: false
      t.string :placeholder_ja, limit: 255, null: false
      t.string :placeholder_en, limit: 255, null: false
      t.string :form_id, limit: 36, null: false
      t.text :type, null: false
      t.boolean :require, null: false, default: false
      t.integer :filter_type, null: true
      t.integer :order, null: false
      t.timestamps
    end

    add_index :questions, :form_id
    add_foreign_key :questions, :forms, column: :form_id, name: 'fk_question_form'
  end
end
