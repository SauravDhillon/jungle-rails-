class SessionsController < ApplicationController
  def new
  end

  # this action is triggered on post /login
  def create
    user = User.find_by_email(params[:email])
    # If user exists AND password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how
     # we keep logged in when they navigate around our website 
       session[:user_id] = user.id
       redirect_to '/'
    else
      # If user login doesn't work, send them back to the login form.
      flash[:error] = 'Invalid email or password'
  redirect_to '/login'
    end
  end 

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

  
end
