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
    @menu.each do |x|
      if x.name == item
        return x.price
      end 
    end
    return nil
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