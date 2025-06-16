class CreateOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :options, id: :string, limit: 36 do |t|
      t.references :question, type: :string, limit: 36, null: false, foreign_key: true, index: { name: 'idx_option_question' }
      t.integer :order, null: false
      t.integer :filter_type, null: true
      t.text :text_ja, null: false
      t.text :text_en, null: false
      t.timestamps
    end
  end
end
