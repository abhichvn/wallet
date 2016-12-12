class BillPayment < ApplicationRecord
  belongs_to :bill
  belongs_to :user

  def self.user_bill_payments
    select("bill_payments.user_id,
            users.name as user_name,
            bills.event,
            bills.amount as bill_amount,
            bill_payments.amount as paid_amount,
            bills.id as bill_id,
            count(DISTINCT user_bills.user_id) as user_count
          ").joins("LEFT JOIN bills
                    ON bills.id = bill_payments.bill_id
                    LEFT JOIN user_bills
                    ON user_bills.bill_id = bill_payments.bill_id
                    LEFT JOIN users
                    ON users.id = bill_payments.user_id
                  ").group("bill_payments.id,
                            users.name,
                            bills.event,
                            bills.amount,
                            bill_payments.amount,
                            bills.id
                          ").order("bill_payments.user_id")
  end
end
