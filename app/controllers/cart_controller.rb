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
    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      { product: product, quantity: quantity }
    end
    @subtotal = calculate_subtotal(@cart_items)

    # Calculate taxes based on default province or the user's selection
    province = params[:province] || "Manitoba"
    tax_data = tax_rates[province]
    gst = @subtotal * tax_data[:gst]
    pst = @subtotal * tax_data[:pst]
    hst = @subtotal * tax_data[:hst]

    @taxes = gst + pst + hst
    @total = @subtotal + @taxes
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

# app/controllers/cart_controller.rb
def create_order
  @cart_items = get_cart_items
  @subtotal = calculate_subtotal(@cart_items)
  @taxes = calculate_taxes(@cart_items, params[:province])
  @total = @subtotal + @taxes

  # Create or find the customer
  customer = Customer.find_or_initialize_by(email: params[:email])
  customer.name = params[:name]
  customer.address = params[:address]
  customer.province = params[:province]

  if customer.save
    # Create the order object (do not save it yet)
    order = customer.orders.new(
      subtotal: @subtotal,
      taxes: @taxes,
      total_price: @total
    )

    # Build order_items (in memory) for each cart item
    @cart_items.each do |item|
      order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        item_price: item[:product].price
      )
    end

    # Now save the order (this will also save the associated order_items due to ActiveRecord associations)
    if order.save
      # Optionally, clear the cart after order creation
      session[:cart] = {}

      @order = order

      # Redirect to order confirmation page (view)
      render :create_order
    else
      flash[:alert] = "There was an issue with your order. Please try again."
      render :show
    end
  end
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

  def update_taxes
    province = params[:province]
    cart_items = get_cart_items
    subtotal = calculate_subtotal(cart_items)

    tax_data = tax_rates[province] || { gst: 0, pst: 0, hst: 0 }
    gst = subtotal * tax_data[:gst]
    pst = subtotal * tax_data[:pst]
    hst = subtotal * tax_data[:hst]
    taxes = gst + pst + hst

    render json: {
      gst: gst.round(2),
      pst: pst.round(2),
      hst: hst.round(2),
      total: (subtotal + taxes).round(2),
      subtotal: subtotal.round(2)
    }
  end


  def get_cart_items
    session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      { product: product, quantity: quantity }
    end
  end
end
