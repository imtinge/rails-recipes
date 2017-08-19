class CreateEventAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :event_attachments do |t|
      t.references :event, foreign_key: true
      t.string :attachment
      t.string :description

      t.timestamps
    end
  end
end
