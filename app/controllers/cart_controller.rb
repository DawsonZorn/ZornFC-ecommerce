class CartController < ApplicationController
  before_action :initialize_cart

  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

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
    @subtotal = calculate_subtotal(@cart_items)
    @taxes = calculate_taxes(@cart_items, params[:province])
    @total = @subtotal + @taxes
    @tax_rates = tax_rates
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

  def calculate_subtotal(cart_items)
    cart_items.sum { |item| item[:product].price * item[:quantity] }
  end

  def calculate_taxes(cart_items, province)
    subtotal = calculate_subtotal(cart_items)
    taxes = 0

    # Use the province-specific tax rates
    if province && tax_rates[province]
      gst = subtotal * tax_rates[province][:gst]
      pst = subtotal * tax_rates[province][:pst]
      hst = subtotal * tax_rates[province][:hst]
      taxes = gst + pst + hst
    end

    taxes
  end

  def tax_rates
    {
      "Manitoba" => { gst: 0.05, pst: 0.07, hst: 0 },
      "Alberta" => { gst: 0.05, pst: 0, hst: 0 },
      "Ontario" => { gst: 0, pst: 0, hst: 0.13 },
      "British Columbia" => { gst: 0.05, pst: 0.07, hst: 0 },
      "New Brunswick" => { gst: 0, pst: 0, hst: 0.15 },
      "Newfoundland and Labrador" => { gst: 0, pst: 0, hst: 0.15 },
      "Northwest Territories" => { gst: 0.05, pst: 0, hst: 0 },
      "Nova Scotia" => { gst: 0, pst: 0, hst: 0.15 },
      "Nunavut" => { gst: 0.05, pst: 0, hst: 0 },
      "Quebec" => { gst: 0.05, pst: 0.9975, hst: 0 },
      "Saskatchewan" => { gst: 0.05, pst: 0.06, hst: 0 }
    }
  end

  def get_cart_items
    session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      { product: product, quantity: quantity }
    end
  end
end
