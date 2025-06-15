class CreateCourseTeachers < ActiveRecord::Migration[7.2]
  def change
    create_table :course_teachers, id: false do |t|
      t.references :course, type: :string, limit: 36, null: false, foreign_key: true, index: { name: 'idx_ct_course' }
      t.string :nameJa, limit: 255, null: false
      t.string :nameEn, limit: 255, null: false
      t.timestamps
    end
  end
end
