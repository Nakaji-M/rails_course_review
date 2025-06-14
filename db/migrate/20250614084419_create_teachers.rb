class CreateTeachers < ActiveRecord::Migration[7.2]
  def change
    create_table :teachers, id: :string, limit: 36 do |t|
      t.string :name, limit: 255, null: false
      t.timestamps
    end
  end
end
