class CreateRegistrationImports < ActiveRecord::Migration[5.0]
  def change
    create_table :registration_imports do |t|
      t.string :status
      t.string :csv_file
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :total_count
      t.integer :success_count
      t.text :error_messages

      t.timestamps
    end
  end
end
