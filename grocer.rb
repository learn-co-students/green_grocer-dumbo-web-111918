require 'pry'

def consolidate_cart(cart)
  # code here
  consolidated_cart = {}
  cart.each do |item|
    item.each do |k, v|
      if consolidated_cart.keys.include?(k) == false
        consolidated_cart[k] = v
        consolidated_cart[k][:count] = 1
      else
        consolidated_cart[k][:count] += 1
      end
    end
  end
  consolidated_cart
end


def apply_coupons(cart, coupons)

  coupon_item_list = []
  valid_number = 0

  coupons.each do |coupon|
    coupon_item_list.push(coupon[:item])
    name = coupon[:item]
    new_entry = {
      price: coupon[:cost],
      clearance: nil,
      count: 1
    }

    if cart.keys.include?(coupon[:item])
      cart.map do |k, v|
        if k == name
          new_entry[:clearance] = v[:clearance]
          v[:count] -= coupon[:num]
          valid_number = v[:count]
        end
      end
      cart[name + " W/COUPON"] = new_entry
      #binding.pry
    end
  end

  # check uniqueness of coupons & add if neccessary
  if coupon_item_list.size != coupon_item_list.uniq.size
    #binding.pry
    coupon_item_list.uniq.each do |item|

      if cart[item][:count] >= 0
        item_num = coupon_item_list.count(item)
        if item_num > 1
          cart[item + " W/COUPON"][:count] = item_num
          #binding.pry
        end
      else
        coupons.each do |coupon|
          if coupon[:item] == item
            cart[item][:count] += coupon[:num]
            binding.pry
            break #<--- once you find a match, stop looking for a match
          end
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.map do |k, v|
    if v[:clearance] == true
      v[:price] =  v[:price] - (v[:price] * 0.20)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  new_cart = consolidate_cart(cart)
# apply coupons if proper number of items present.....
  cart_w_coupons = apply_coupons(new_cart, coupons)
  discount_cart = apply_clearance(cart_w_coupons)

  price = 0
  discount_cart.each do |k, v|
    price += v[:price] * v[:count]
  end

  if price > 100
    price = price - (price * 0.10)
  end

  price
end
