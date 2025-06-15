class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions, id: :string, limit: 36 do |t|
      t.references :form, type: :string, limit: 36, null: false, foreign_key: true
      t.string :placeholder_ja, limit: 255, null: false
      t.string :placeholder_en, limit: 255, null: false
      t.integer :filter_type, null: true
      t.integer :order, null: false
      t.text :text_ja, null: false
      t.text :text_en, null: false
      t.text :description_ja, null: false
      t.text :description_en, null: false
      t.text :type, null: false
      t.boolean :require, null: false, default: false
      t.timestamps
    end
  end
end
