module Admin::SalesHelper
  def active_sale?
    Sale.active.any?  #this is calling class method active on Sale which return active sales, this is for checking any active sales using SQL query syntax
    #Since this method is defined here in helpers it becomes automatically available in views 
  end
end