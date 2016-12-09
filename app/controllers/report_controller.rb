class ReportController < ApplicationController
  def index
    @bills = Bill.all
    @bill_payments = BillPayment.user_bill_payments
  end
end
