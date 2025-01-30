require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
   before do 
    @category = Category.create(name: "Trees")
   end

   it "saves successfully when all fields are set" do
    product = Product.new(
      name: "Void Fennel",
      price_cents: 8765,
      quantity: 2,
      category: @category
    )
    expect(product).to be_valid
   end
   
   it "is not valid without a name" do
    product = Product.new(
      name: nil,
      price_cents: 8765,
      quantity: 2,
      category: @category
    )
    expect(product).not_to be_valid
    expect(product.errors.full_messages).to include("Name can't be blank")
   end

   it "is not valid without a price" do
    product = Product.new(
      name: "Void Fennel",
      price_cents: nil,
      quantity: 2,
      category: @category
    )
    expect(product).not_to be_valid
    expect(product.errors.full_messages).to include("Price can't be blank")
  end

   it "is not valid without a quantity" do
     product = Product.new(
      name: "Void Fennel",
      price_cents: 8765,
      quantity: nil,
      category: @category
     )
     expect(product).not_to be_valid
     expect(product.errors.full_messages).to include("Quantity can't be blank")
   end

   it "is not valid without a category" do
    product = Product.new(
      name: "Void Fennel",
      price_cents: 8765,
      quantity: 2,
      category: nil
    )
    expect(product).not_to be_valid
    expect(product.errors.full_messages).to include("Category can't be blank")
   end

  end
end


