class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception

  #The helper_method line (helper_method :current_user) makes the method available in your views, allowing you to use current_user and logged_in? directly in your views (e.g., to display the user's name or to check if they are logged in) without needing to call them explicitly in your controller logic. By defining these methods in the ApplicationController, you make them globally accessible to both your controller and views.
  # Helper method to fetch the current user (if logged in)
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] #here we check for user in User table using its user id 
  end
  helper_method :current_user

  # Method to check if a user is logged in
  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  # Redirect users if they're not logged in
  def authenticate_user!
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  private

  def cart
    @cart ||= cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
  end
  helper_method :cart

  def enhanced_cart
    @enhanced_cart ||= Product.where(id: cart.keys).map {|product| { product:product, quantity: cart[product.id.to_s] } }
  end
  helper_method :enhanced_cart

  def cart_subtotal_cents
    enhanced_cart.map {|entry| entry[:product].price_cents * entry[:quantity]}.sum
  end
  helper_method :cart_subtotal_cents


  def update_cart(new_cart)
    cookies[:cart] = {
      value: JSON.generate(new_cart),
      expires: 10.days.from_now
    }
    cookies[:cart]
  end
end
