class Admin::SalesController < ApplicationController

  def index
    @sales = Sale.all  #we need sale model for this 
  end
end
