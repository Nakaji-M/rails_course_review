class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments, id: false do |t|
      t.string :id, limit: 36, null: false, primary_key: true, default: -> { 'UUID()' }
      t.string :name, limit: 255, null: false
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end
  end
end
