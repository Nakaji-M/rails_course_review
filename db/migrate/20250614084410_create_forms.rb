class CreateForms < ActiveRecord::Migration[7.2]
  def change
    create_table :forms, id: :string, limit: 36 do |t|
      t.integer :year, null: false
      t.timestamps
    end

    add_index :forms, :year, unique: true, name: 'uniq_form_year'
  end
end
