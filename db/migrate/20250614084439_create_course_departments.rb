class CreateCourseDepartments < ActiveRecord::Migration[7.2]
  def change
    create_table :course_departments, id: false do |t|
      t.string :course_id, limit: 36, null: false
      t.string :department_id, limit: 36, null: false
      t.timestamps
    end

    add_index :course_departments, [:course_id, :department_id], primary: true
    add_index :course_departments, :course_id, name: 'idx_cd_course'
    add_index :course_departments, :department_id, name: 'idx_cd_department'
    add_foreign_key :course_departments, :courses, column: :course_id, name: 'fk_cd_course'
    add_foreign_key :course_departments, :departments, column: :department_id, name: 'fk_cd_department'
  end
end
