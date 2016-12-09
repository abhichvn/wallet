class CreateUserPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :user_payments do |t|
      t.belongs_to :user, index: true
      t.integer :payable_id
      t.timestamps
    end
  end
end
