require "Order"

RSpec.describe Order do
  context "when items have been added to order" do
    it "returns basket contents" do
      order = Order.new
      order.update_basket("cheeseburger")
      order.update_basket("cheeseburger")
      order.update_basket("fries", 2)
      expect( order.basket_summary ).to eq [{:item => "cheeseburger", :quantity => 2}, {:item => "fries", :quantity => 2}]
    end
  end

  context "when no items have been added to order" do
    it "returns an empty list" do
      order = Order.new
      expect( order.basket_summary ).to eq []
    end
  end
end