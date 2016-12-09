class CreateBillPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_payments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :bill, index: true
      t.integer :amount
      t.timestamps
    end
  end
end
