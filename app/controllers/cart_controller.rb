class CartController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = @cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end.compact
  end

  def add
    product_id = params[:product_id].to_s
    @cart[product_id] ||= 0
    @cart[product_id] += params[:quantity].to_i
    save_cart
    redirect_to cart_path, notice: "Product added to cart."
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
