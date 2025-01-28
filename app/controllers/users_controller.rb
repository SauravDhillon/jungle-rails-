class UsersController < ApplicationController
  def new
  end

  def show
    @user = current_user #current_user is defined in Application controller
  end 

  #In the create action, you are using the user.save method, which ensures that the validations in the User model are run, including the one provided by has_secure_password.

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id #we are setting cookie by assiging user_id to session so that users stays logged in after registering or any page reloads 
      redirect_to '/'
    else
      flash[:error] = user.errors.full_messages.join(', ')
      redirect_to '/signup' 
    end
  end

  private

  #By using params.require(:user).permit(...), you're explicitly defining which attributes are allowed to be assigned to the User model. Without strong parameters, malicious users could potentially send extra data (e.g., admin: true) in the form submission and modify fields that they shouldn’t have access to.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
