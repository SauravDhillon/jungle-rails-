require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it "is valid with all required fields" do
      user = User.new(
        first_name: "John",
        last_name: "Wright",
        email: "john1122@gmail.com",
        password: 'johnny22',
        password_confirmation: 'johnny22'
      )
      expect(user).to be_valid
    end

    it 'requires password and password_confirmation' do
       user = User.new(password: nil, password_confirmation: nil)
       expect(user).not_to be_valid
       expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it "is not valid if passwords don't match" do
       user = User.new(
        first_name: "Adam",
        last_name: "Brown",
        email: "adambrown22@gmail.com",
        password: "adamh123",
        password_confirmation: "adam333"
       )
       expect(user).not_to be_valid
       expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it "requires a unique email (case insensitive)" do
      #create! immediately saves the record in the database.
      #This ensures that when we later attempt to create another user with the same email (but different casing), we can check if the uniqueness validation works as expected.
       User.create!(
        first_name: 'Jack',
        last_name: 'Sparrow',
        email: 'TEST@TEST.com',
        password: 'jack123',
        password_confirmation: 'jack123'
       )

       user = User.new(
        first_name: 'Tom',
        last_name: 'Cruise',
        email: 'test@test.COM',
        password: 'tommy234',
        password_confirmation: 'tommy234'
       )

       expect(user).not_to be_valid
       expect(user.errors.full_messages).to include('Email has already been taken') #Rails' default uniqueness validation error message for validates :email, uniqueness: true is "has already been taken"
    end 
  

    it "requires first name, last name and email" do
        user = User.new(
        first_name: nil,  
        last_name: nil,
        email: nil
        )
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include(
          "First name can't be blank",
          "Last name can't be blank",
          "Email can't be blank"
        )
    end

    #password must have minimum length when user account is being created
    it "validates password to have minimum length of 6 characters" do
       user = User.new(
        first_name: 'Tom',
        last_name: 'Cruise',
        email: 'tommy123@gmail.com',
        password: 'teri',
        password_confirmation: 'teri'
       )
       expect(user).not_to be_valid
       expect(user.errors.full_messages).to include(
        'Password is too short (minimum is 6 characters)'
       )
    end

  end

  describe '.authenticate_with_credentials' do
    before do
      @user = User.create!(
        first_name: 'Jimmy',
        last_name: 'Carter',
        email: 'jimmy234@gmail.com',
        password: 'jimmy789',
        password_confirmation: 'jimmy789'
      )
    end

    it 'returns user when given correct email and password' do
      authenticated_user = User.authenticate_with_credentials('jimmy234@gmail.com', 'jimmy789')
      expect(authenticated_user).to eq(@user)
    end

    it 'returns nil if password is incorrect' do 
      authenticated_user = User.authenticate_with_credentials('jimmy234@gmail.com', 'jimney234')
      expect(authenticated_user).to be_nil
    end 

    it 'authenticates even if email has spaces around it' do
     authenticated_user = User.authenticate_with_credentials(' jimmy234@gmail.com ', 'jimmy789')
     expect(authenticated_user).to eq(@user)
    end

    it 'authenticates even if email has mixed case' do
      authenticated_user = User.authenticate_with_credentials('JIMMy234@gmail.com', 'jimmy789')
      expect(authenticated_user).to eq(@user)
    end

    it 'returns nil if email does not exist' do
      authenticated_user = User.authenticate_with_credentials('notfound@example.com', 'jimmy789')
      expect(authenticated_user).to be_nil
    end
  end
end
