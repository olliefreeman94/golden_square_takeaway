class Order
  def initialize
    @basket = Hash.new(0)
  end

  def update_basket(item, quantity = 1)
    @basket[item] += quantity
    if @basket[item] == 0
      @basket.delete(item)
    end
  end

  def basket
    return @basket
  end
end