class Bill < ApplicationRecord

  attr_accessor :event_attendes, :bill_contributors, :contributions

  has_many :user_bills
  has_many :users, :through => :user_bills
  has_many :bill_payments

  validates :event,
            presence: true
  validates :event,
            inclusion: { in: %w(lunch dinner snacks),
            message: "%{value} is not a valid event" },
            if: :event
  validates :entry_date,
            presence: true
  validates :location,
            presence: true
  validates :amount,
            presence: true
  validates :amount,
            numericality: { only_integer: true },
            if: :amount
  validates :event_attendes, :bill_contributors, :contributions,
            presence: true

  validate :cross_verify_contributors, if: Proc.new { event_attendes.present? && bill_contributors.present? }
  validate :verify_contributions, if: Proc.new { contributions.present? && bill_contributors.present? }

  EVENTS = [["Lunch", "lunch"], ["Dinner", "dinner"], ["Snacks", "snacks"]]

  private

  def cross_verify_contributors
    errors.add(:bill_contributors, "Bill contributors should be included in event attendes") unless (event_attendes & bill_contributors).sort == bill_contributors.sort
  end

  def verify_contributions
    errors.add(:contributions, "Bill contributors and no of amount mismatch or invalid") if contributions.delete_if {|number| number.to_i.eql?(0)}.length != bill_contributors.length
    errors.add(:contributions, "Contributions and total amount is mismatch") if contributions.delete_if {|number| number.to_i.eql?(0)}.map(&:to_i).reduce(0, :+) != amount.to_i
  end

end
