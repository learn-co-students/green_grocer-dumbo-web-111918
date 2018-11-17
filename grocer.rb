require "pry"

def consolidate_cart(cart)
  # code here
  consolidated_cart_hash = Hash.new
  cart.each do |item|
    item.each do |product, value|
      if consolidated_cart_hash.has_key?(product) == false
        consolidated_cart_hash[product] = value
        consolidated_cart_hash[product][:count] = 1
      else
        consolidated_cart_hash[product][:count] += 1
      end
    end
  end
  return consolidated_cart_hash
end

def apply_coupons(cart, coupons)
  # code here
  item_with_coupon = {}
  coupons.each do |product|
    if cart.keys.include?(product[:item]) && cart[product[:item]][:count] >= product[:num]
      product_name = String.new
      product_name_with_coupon = String.new
      product_name = product[:item]
      product_name_with_coupon = product_name + " W/COUPON"
      if cart.keys.include?(product_name_with_coupon) == false
        cart[product_name_with_coupon] = {}
        cart[product_name_with_coupon][:clearance] = cart[product_name][:clearance]
        cart[product_name_with_coupon][:price] = product[:cost]
        cart[product_name_with_coupon][:count] = 1
        cart[product_name][:count] -= product[:num]
      else
        cart[product_name_with_coupon][:count] += 1
        cart[product_name][:count] -= product[:num]
      end
    end
   end
   return cart
end

def apply_clearance(cart)
  # code here
  cart.collect do |product, attributes_hash|
    if attributes_hash[:clearance] == true
      attributes_hash[:price] = (attributes_hash[:price] * 0.80).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  # code here
  # consolidated_cart = {}
  total_cost = 0
  consolidated_cart = consolidate_cart(cart)
  consolidated_cart = apply_coupons(consolidated_cart, coupons)
  consolidated_cart = apply_clearance(consolidated_cart)
  # binding.pry
  consolidated_cart.each do |item, attributes|
    total_cost += attributes[:price] * attributes[:count] if attributes[:count] > 0
  end
  total_cost = (total_cost *0.9).round(2) if total_cost > 100
  # binding.pry
  return total_cost
end
# {"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}
