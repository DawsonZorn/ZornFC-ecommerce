class Product < ApplicationRecord
  has_many :order_items
  has_and_belongs_to_many :categories, join_table: "product_categories"

  # Add Active Storage attachment for image
  has_one_attached :image

  # Scopes
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where("created_at >= ?", 30.days.ago) }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.ransackable_associations(auth_object = nil)
    [ "categories", "image_attachment", "image_blob", "order_items" ]
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "name", "new_arrival", "on_sale", "price", "stock_quantity", "updated_at" ]
  end
end
