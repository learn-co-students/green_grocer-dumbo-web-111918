require 'pry'
def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        result[type] = attributes
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    person = coupon[:item]
    if cart[person] && cart[person][:count] >= coupon[:num]
      if cart["#{person} W/COUPON"]
        cart["#{person} W/COUPON"][:count] += 1
      else
        cart["#{person} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{person} W/COUPON"][:clearance] = cart[person][:clearance]
      end
      cart[person][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |person, value|
    if value[:clearance]
      updated_price = value[:price] * 0.80
      value[:price] = updated_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |person, value|
    total += value[:price] * value[:count]
  end
  total = total * 0.9 if total > 100
  total
end
