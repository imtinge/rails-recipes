class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.string :status, default: 'pending'
      t.string :uuid
      t.references :event, foreign_key: true
      t.references :ticket, foreign_key: true
      t.references :user, forgeign_key: true
      t.string :name
      t.string :email
      t.string :cellphone
      t.string :website
      t.text :bio

      t.timestamps
    end
    add_index :registrations, :uuid, unique: true
  end
end
