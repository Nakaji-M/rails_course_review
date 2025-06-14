class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses, id: :string, limit: 36 do |t|
      t.string :department_id, limit: 36, null: false
      t.integer :ocw_id, null: false
      t.string :course_number, limit: 100, null: false
      t.string :title_ja, limit: 255, null: false
      t.string :title_en, limit: 255, null: false
      t.integer :year, null: false
      t.integer :start_quarter, null: false
      t.integer :end_quarter, null: false
      t.timestamps
    end

    add_index :courses, :department_id, name: 'idx_course_department'
    add_foreign_key :courses, :departments, column: :department_id, name: 'fk_course_department'
  end
end
