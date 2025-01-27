class OrdersController < ApplicationController
  
  #Now, when you call Order.includes(line_items: :product), it uses ActiveRecord’s eager loading feature. Here’s what happens step by step:

  #Order.includes(line_items: :product) tells ActiveRecord to eagerly load the line_items associated with the Order, and within that, also eagerly load the product associated with each line_item. So, it makes two queries:

#One query to fetch all orders (with their line_items already preloaded).One query to fetch all products for the line_items that belong to the order.This means that it avoids making additional queries later when you access line_item.product within the view, preventing the N+1 query problem.

#The SQL Query Itself:

#The SQL query for Order.includes(line_items: :product) would look something like this:
#SELECT orders.* FROM orders WHERE orders.id = ?
#This fetches the order itself. Then, based on that order_id, ActiveRecord will automatically fetch the line_items for that order (because of the has_many :line_items association).

#Then, in a second query, it will fetch the products associated with those line_items, like so:
#SELECT products.* FROM products WHERE products.id IN (line_item_product_ids)
#Connecting Everything Together:

#Once you have the order and line_items loaded, you can access the line_items directly via @order.line_items.
#Since line_item belongs to product, you can then access the product details from the line item like this: line_item.product.

  def show
    @order = Order.includes(line_items: :product).find(params[:id])
    @line_items = @order.line_items
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

end
