class Menu
  def initialize
    @menu = []
  end

  def add(item)
    @menu << item
  end

  def all
    return format_items
  end

  def item_price(item)
    return nil unless @menu.one? { |x| x.name == item }
    @menu.each { |y| return y.price if y.name == item }
  end

  private

  def format_items
    array = []
    @menu.each do |item|
      hash = {}
      hash[:name] = item.name
      hash[:price] = item.price
      array << hash
    end
    return array
  end
end