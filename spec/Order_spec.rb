require "Order"

RSpec.describe Order do
  context "when items have been added to order" do
    it "returns basket contents" do
      order = Order.new
      order.update_basket("cheeseburger")
      order.update_basket("cheeseburger")
      order.update_basket("fries", 2)
      expect( order.basket ).to eq (
        {"cheeseburger" => 2, "fries" => 2}
      )
    end
  end

  context "when no items have been added to order" do
    it "returns an empty hash" do
      order = Order.new
      expect( order.basket ).to eq (
        {}
      )
    end
  end
end