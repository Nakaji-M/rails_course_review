class CreateCourseDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :course_departments, id: false do |t|
      t.string :course_id, limit: 36, null: false
      t.string :department_id, limit: 36, null: false
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP' }
    end

    add_index :course_departments, [:course_id, :department_id], primary: true
    add_index :course_departments, :course_id, name: 'idx_cd_course'
    add_index :course_departments, :department_id, name: 'idx_cd_department'
    add_foreign_key :course_departments, :courses, column: :course_id, name: 'fk_cd_course'
    add_foreign_key :course_departments, :departments, column: :department_id, name: 'fk_cd_department'
  end
end
