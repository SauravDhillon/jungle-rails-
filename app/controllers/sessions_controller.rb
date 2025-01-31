class SessionsController < ApplicationController
  def new
  end

  def create
    # here we are using user model class method
    user = User.authenticate_with_credentials(params[:email], params[:password])
    # Save the user id inside the browser cookie. This is how
   # we keep logged in when they navigate around our website 
    if user
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



