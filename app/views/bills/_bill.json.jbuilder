json.extract! bill, :id, :event, :entry_date, :location, :amount, :created_at, :updated_at
json.url bill_url(bill, format: :json)