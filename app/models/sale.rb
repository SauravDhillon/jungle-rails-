class Sale < ApplicationRecord

  #AR scope
  def self.active
    where("sales.starts_on <= ? AND sales.ends_on >= ?", Date.current, Date.current) # this is for checking any active sales using SQL query syntax 
  end

  # methods below are being used in _sale.html.erb partial file to 
  # to make code modular to display status upcoming, finished or active 
  def finished? 
    ends_on < Date.current
  end

  def upcoming?
    starts_on > Date.current
  end

  def active?
    !upcoming? && !finished?
  end
end
