class Product < ApplicationRecord
  has_many :order_items
  has_and_belongs_to_many :categories, join_table: "product_categories"

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
