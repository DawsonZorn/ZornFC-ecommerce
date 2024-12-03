class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories) # Load products and their categories
    @categories = Category.all

    # Apply filters
    @products = @products.on_sale if params[:filter] == "on_sale"
    @products = @products.new_products if params[:filter] == "new"
    @products = @products.all if params[:filter] == "all" # Show all products when 'all' filter is selected

    # Search and category filtering
    if params[:search].present? || params[:category_id].present?
      if params[:search].present?
        @products = @products.where("products.name LIKE :search OR products.description LIKE :search", search: "%#{params[:search]}%")
      end

      if params[:category_id].present? && params[:category_id] != "all"
        @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
      end
    end
  end
end
