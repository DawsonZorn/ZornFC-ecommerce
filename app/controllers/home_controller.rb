class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories) # Load products and their categories
    @categories = Category.all

    # Apply filters
    @products = @products.on_sale if params[:filter] == "on_sale"
    @products = @products.new_products if params[:filter] == "new"
  end
end
