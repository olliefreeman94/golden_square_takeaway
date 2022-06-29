class Interface
  def initialize(menu, order, messenger)
    @menu = menu
    @order = order
    @messenger = messenger
  end

  def list_menu
    fail "No menu found." if @menu.all == []
    return format_menu(@menu.all)
  end

  def add_item(item, quantity = 1)
    fail "Number of items must be greater than zero." if quantity <= 0
    fail "Item not found." if @menu.item_price(item) == nil
    @order.update_basket(item, quantity)
  end

  def remove_item(item, quantity = 1)
    fail "Number of items must be greater than zero." if quantity <= 0
    fail "Item not found." unless order_contains?(item)
    fail "Cannot remove more items than have been added to order." unless can_remove?(item, quantity)
    @order.update_basket(item, quantity * -1)
  end

  def order_summary
    fail "Order not found." if @order.basket == {}
    return "Order summary:\n" + format_summary 
  end

  def confirm_order
    fail "Order not found." if @order.basket == {}
    message = generate_SMS
    if @messenger.send_notification(message) == message
      return "Order confirmation:\n" + format_summary
    end
  end

  private

  def format_menu(menu)
    string = ""
    menu.each { |item| string += "#{item[:name]}: £#{"%.2f" % item[:price]}\n" }
    return string
  end

  def order_contains?(item)
    return @order.basket.keys.include?(item)
  end

  def can_remove?(item, quantity)
    basket = @order.basket
    return basket[item] - quantity >= 0
  end

  def format_summary
    string = ""
    total = 0
    @order.basket.each do |key, value|
      item = key
      quantity = value
      price = @menu.item_price(item)
      string += "#{quantity} x #{item} @ £#{"%.2f" % price}\n"
      total += quantity * price
    end
    return string + "Total: £#{"%.2f" % total}\n"
  end

  def generate_SMS
    delivery_time = (Time.new + (60 * 30)).strftime("%l:%M %P")
    return "Thanks for your order! Estimated delivery time: #{delivery_time}"
  end
end