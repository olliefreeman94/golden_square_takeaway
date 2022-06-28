class Order
  def initialize
    @basket = Hash.new(0)
  end

  def update_basket(item, quantity = 1)
    @basket[item] += quantity
  end

  def basket_summary
    return format_summary
  end

  private

  def format_summary
    array = []
    @basket.each { |key, value| array << {:item => key, :quantity => value} }
    return array
  end
end