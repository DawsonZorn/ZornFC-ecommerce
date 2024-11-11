class Category < ApplicationRecord
  has_and_belongs_to_many :products, join_table: "product_categories"

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "name", "updated_at" ]
  end
end
