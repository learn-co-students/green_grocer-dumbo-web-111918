def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item|
    item.each do |k,v|
      if (new_hash[k] == nil) || (new_hash[k][:price] != v[:price])
        new_hash[k] = v
        new_hash[k][:count] = 1
      else
        new_hash[k][:count] += 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_cart = {}
  coupons.each do |x|
    cart.each do |k,v|
      if v[:count] >= x[:num]
        if x[:item] == k
          if (new_cart["#{k} W/COUPON"] == nil)
            new_cart["#{k} W/COUPON"] = {}
            new_cart["#{k} W/COUPON"][:count] = 0
          end
          new_cart["#{k} W/COUPON"][:count] += 1
          new_cart["#{k} W/COUPON"][:price] = x[:cost]
          new_cart["#{k} W/COUPON"][:clearance] = v[:clearance]
          cart[k][:count] = v[:count] - x[:num]
          cart[k][:price] = v[:price]
        end
      end
    end
  end
  new_cart.merge(cart)
end

def apply_clearance(cart)
  cart.each {|k,v|
    if v[:clearance]
      cart[k][:price] -= v[:price] * 0.2
    end
  }
  cart
end

def checkout(cart, coupons)
  cost = 0.00
  cons_cart = consolidate_cart(cart)
  coup_cart = apply_coupons(cons_cart, coupons)
  clear_cart = apply_clearance(coup_cart)
  coup_cart.each do |k,v|
    cost += v[:price]
  end
  if cost > 100.0
    cost *= 0.9
  end
  cost
end