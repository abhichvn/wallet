class CreateBills < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.string :event
      t.datetime :entry_date
      t.string :location
      t.integer :amount

      t.timestamps
    end
  end
end
