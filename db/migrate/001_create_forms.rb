class CreateForms < ActiveRecord::Migration[7.0]
  def change
    create_table :forms, id: false do |t|
      t.string :id, limit: 36, null: false, primary_key: true, default: -> { 'UUID()' }
      t.integer :year, null: false
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end

    add_index :forms, :year, unique: true, name: 'uniq_form_year'
  end
end
