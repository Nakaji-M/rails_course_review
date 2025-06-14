class CreateTeachers < ActiveRecord::Migration[7.2]
  def change
    create_table :teachers, id: false do |t|
      t.string :id, limit: 36, null: false, primary_key: true, default: -> { 'UUID()' }
      t.string :name, limit: 255, null: false
      t.timestamps
    end
  end
end
