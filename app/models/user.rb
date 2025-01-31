class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  # class method for authentication
def self.authenticate_with_credentials(email, password)
  # Trim whitespace & downcase email
  cleaned_email = email.strip.downcase

  # Find the user ignoring case sensitivity
  user = User.find_by('lower(email) = ?', cleaned_email)

  # Authenticate user with password 
  # Uses authenticate from has_secure_password to verify the password.
 # Returns the user if authentication is successful, otherwise nil.
  user&.authenticate(password) ? user : nil

end

end

#The has_secure_password method is a Rails helper that:
#Ensures the password and password_confirmation fields are validated.
#Automatically hashes the password using bcrypt before saving it to the database.

#In the create action, you are using the user.save method, which ensures that the validations in the User model are run, including the one provided by has_secure_password.

