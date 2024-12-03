class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories) # Load products and their categories
    @categories = Category.all

    # Apply filters
    @products = @products.on_sale if params[:filter] == "on_sale"
    @products = @products.new_products if params[:filter] == "new"

    if params[:search].present? || params[:category_id].present?
      @products = @products.joins(:category).where("products.name LIKE :search OR products.description LIKE :search", search: "%#{params[:search]}%") if params[:search].present?

      if params[:category_id].present?
        @products = @products.where(category_id: params[:category_id])
      end
    else
      @products = []
    end
  end
end
