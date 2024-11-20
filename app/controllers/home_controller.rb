class HomeController < ApplicationController
  def index
    @products = Product.includes(:categories) # Load products and their categories
    @categories = Category.all
  end
end
