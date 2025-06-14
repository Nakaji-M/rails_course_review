class CreateCourseTeachers < ActiveRecord::Migration[7.2]
  def change
    create_table :course_teachers, id: false do |t|
      t.string :course_id, limit: 36, null: false
      t.string :teacher_id, limit: 36, null: false
      t.timestamps
    end

    add_index :course_teachers, [:course_id, :teacher_id], primary: true
    add_index :course_teachers, :course_id, name: 'idx_ct_course'
    add_index :course_teachers, :teacher_id, name: 'idx_ct_teacher'
    add_foreign_key :course_teachers, :courses, column: :course_id, name: 'fk_ct_course'
    add_foreign_key :course_teachers, :teachers, column: :teacher_id, name: 'fk_ct_teacher'
  end
end
