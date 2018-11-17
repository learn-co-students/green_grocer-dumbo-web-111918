def consolidate_cart(cart)
  hash = {}
  cart.each do |product|
    product.each do |name, details|
      if !((hash.keys).include?(name))
        details[:count] = cart.count(product)
        hash[name] = details
      end 
    end 
  end 
  hash
end

def apply_coupons(cart, coupons)
  con_cart = cart
  hash = cart
  coupons.each do |coupon|
    coupon.each do |key, value|
      if (con_cart.keys).include?(value)
        if (hash.keys).include?(value + " W/COUPON")
          hash[value + " W/COUPON"][:count] += 0
        else 
          hash[value + " W/COUPON"] = {price: coupon[:cost], clearance: con_cart[value][:clearance], count: (con_cart[value][:count])/(coupon[:num])}
          hash[value] = {price: con_cart[value][:price], clearance: con_cart[value][:clearance], count: (con_cart[value][:count])%(coupon[:num])}
        end 
      end 
    end 
  end
  hash
end

def apply_clearance(cart)
  hash = cart
  cart.each do |name, details|
    if (details.values).include?(true)
      hash[name][:price] = (cart[name][:price] * 0.80).round(2)
    end
  end
  hash
end

def checkout(cart, coupons)
  total = 0
  hash = consolidate_cart(cart)
  apply_coupons(hash, coupons)
  apply_clearance(hash)
  hash.each do |item, details|
    total += details[:price] * details[:count]
  end 
  if total > 100
    return (total * 0.9).round(2)
  else
    return total
  end 
end
