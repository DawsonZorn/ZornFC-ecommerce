class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[Processing Shipped Completed Canceled] }
end
