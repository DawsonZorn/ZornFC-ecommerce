class CheckoutController < ApplicationController
  def buy_now
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    # Calculate the total price
    total_amount = (product.price * quantity * 100).to_i # Stripe uses cents

    # Create a Stripe Payment Intent
    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items:           [
        {
          price_data: {
            currency:     "cad",
            product_data: {
              name: product.name
            },
            unit_amount:  (product.price * 100).to_i
          },
          quantity:   quantity
        }
      ],
      mode:                 "payment",
      success_url:          "#{root_url}checkout/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           "#{root_url}products/#{product.id}",
      customer_email:       params[:email]
    )

    # Redirect to Stripe Checkout
    redirect_to session.url, allow_other_host: true
  end

  def success
    # Confirm payment success and mark order as paid
    session_id = params[:session_id]
    session = Stripe::Checkout::Session.retrieve(session_id)

    if session.payment_status == "paid"
          # Save payment info in your database (e.g., Payment ID, customer email)
          Order.create(
  customer_email:    session.customer_details.email, # Stripe provides the email
  stripe_payment_id: session.payment_intent, # Stripe Payment ID
  total_price:       session.amount_total / 100.0, # Stripe returns the amount in cents
  status:            "Paid"
)
      flash[:notice] = "Payment Successful!"
      redirect_to root_path
    else
      flash[:alert] = "Payment failed. Please try again."
      redirect_to root_path
    end
  end
end
