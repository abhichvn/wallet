module ApplicationHelper

  def settlement_info(bill_payments)
    h = Hash.new
    bill_payments.each do |bill_payment|
      h[bill_payment.user_id.to_s] = Hash.new unless h[bill_payment.user_id.to_s].present?
      h[bill_payment.user_id.to_s]["user_name"] = bill_payment.user_name

      h[bill_payment.user_id.to_s]["paid_amount"] = 0 unless h[bill_payment.user_id.to_s]["paid_amount"].present?
      h[bill_payment.user_id.to_s]["paid_amount"] += bill_payment.paid_amount

      h[bill_payment.user_id.to_s]["bill_amount"] = 0 unless h[bill_payment.user_id.to_s]["bill_amount"].present?
      h[bill_payment.user_id.to_s]["bill_amount"] += (bill_payment.bill_amount/bill_payment.user_count)
    end

    h.each do |key, value|
      h[key]["settle_amount"] = h[key]["paid_amount"] - h[key]["bill_amount"]
    end

    return h
  end

end
