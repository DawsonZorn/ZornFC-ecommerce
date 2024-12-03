class CartController < ApplicationController
  before_action :initialize_cart

  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    # Assuming you are using session to store the cart
    session[:cart] ||= {}
    session[:cart][product.id.to_s] ||= 0
    session[:cart][product.id.to_s] += quantity

    redirect_to cart_path, notice: "Product added to cart."
  end

  def show
    # Retrieve all products in the cart based on product IDs stored in the session
    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      { product: product, quantity: quantity }
    end
  end

  def update
    product_id = params[:product_id].to_s
    if @cart[product_id]
      @cart[product_id] = params[:quantity].to_i
      @cart.delete(product_id) if @cart[product_id] <= 0
      save_cart
    end
    redirect_to cart_path, notice: "Cart updated."
  end

  def remove
    product_id = params[:product_id].to_s
    @cart.delete(product_id)
    save_cart
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def initialize_cart
    @cart = session[:cart] ||= {}
  end

  def save_cart
    session[:cart] = @cart
  end
end
