require "pry"
def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |product|
    product.each do |label, details|
      if !consolidated_cart[label]
        consolidated_cart[label] = details
        consolidated_cart[label][:count] = 1
      else
        consolidated_cart[label][:count] += 1
      end
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    #see if there are enough items to apply_coupons
    if cart[coupon[:item]] && (cart[coupon][:item][:count]] >= coupon[:num])
      cart[coupon][:item][:count]] -= coupon[:num]
      cart << {"#{coupon[:item]} W/COUPON" => {:price => coupon[:cost], :clearance => cart[coupon[:item][:clearance]], :count => 1}}
    end
    #If yes, change quantity of regular items and add couponed item to cart
  end
  return cart
end

def apply_clearance(cart)
  # code here
end

def checkout(cart, coupons)
  # code here
end
