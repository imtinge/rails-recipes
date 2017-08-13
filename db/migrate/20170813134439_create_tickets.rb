class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :event, foreign_key: true
      t.string :name
      t.text :description
      t.integer :price

      t.timestamps
    end
  end
end
