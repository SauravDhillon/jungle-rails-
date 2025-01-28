class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end

#The has_secure_password method is a Rails helper that:
#Ensures the password and password_confirmation fields are validated.
#Automatically hashes the password using bcrypt before saving it to the database.

#In the create action, you are using the user.save method, which ensures that the validations in the User model are run, including the one provided by has_secure_password.