class Interface
  def initialize(menu)
    @menu = menu
    @current_order = nil
  end

  def list_menu
    fail "No menu found." if @menu.all == []
    return format_menu(@menu.all)
  end

  def add_item(item, quantity = 1)
    fail "Number of items must be greater than zero." if quantity <= 0
    fail "Item not found." if @menu.item_price(item) == nil
    if @current_order == nil
      @current_order = Order.new
    end
  end

  def order_summary
  end

  private

  def format_menu(menu)
    string = ""
    menu.each { |item| string += "#{item[:name]}: £#{"%.2f" % item[:price]}\n" }
    return string
  end

  def format_summary
  end
end