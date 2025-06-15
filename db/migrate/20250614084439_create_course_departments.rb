class CreateCourseDepartments < ActiveRecord::Migration[7.2]
  def change
    create_table :course_departments, id: false do |t|
      t.references :course, type: :string, limit: 36, null: false, foreign_key: true, index: { name: 'idx_cd_course' }
      t.references :department, type: :string, limit: 36, null: false, foreign_key: true, index: { name: 'idx_cd_department' }
      t.timestamps
    end

    add_index :course_departments, [:course_id, :department_id], unique: true
  end
end
