require "Interface"
require "timecop" 

RSpec.describe Interface do
  it "lists all menu items and prices" do
    menu = double :menu, all: [
      {:name => "cheeseburger", :price => 9.5}, 
      {:name => "fries", :price => 3.5}, 
      {:name => "milkshake", :price => 5}
    ]
    order = double :order
    messenger = double :notification_sender
    interface = Interface.new(menu, order, messenger)
    expect( interface.list_menu ).to eq "cheeseburger: £9.50\nfries: £3.50\nmilkshake: £5.00\n"
  end

  it "returns an error with an empty menu" do
    menu = double :menu, all: []
    order = double :order
    messenger = double :notification_sender
    interface = Interface.new(menu, order, messenger)
    expect{ interface.list_menu }.to raise_error "No menu found."
  end

  context "when items added to order" do
    before(:example) do
      menu = double :menu
      allow(menu).to receive(:item_price).with("cheeseburger").and_return(9.5)
      allow(menu).to receive(:item_price).with("fries").and_return(3.5)
      allow(menu).to receive(:item_price).with("milkshake").and_return(5)
      @order = double :order, update_basket: nil
      @messenger = double :notification_sender
      @interface = Interface.new(menu, @order, @messenger)
      @interface.add_item("cheeseburger", 2)
      @interface.add_item("fries")
      @interface.add_item("milkshake", 2)
      allow(@order).to receive(:basket).and_return(
        {"cheeseburger" => 2, "fries" => 1, "milkshake" => 2}
      )
    end

    context "when no items are removed from order" do
      before(:example) do
        allow(@order).to receive(:basket).and_return(
            {"cheeseburger" => 2, "fries" => 1, "milkshake"=> 2}
        )
      end

      it "returns order summary" do
        expect( @interface.order_summary ).to eq "Order summary:\n2 x cheeseburger @ £9.50\n1 x fries @ £3.50\n2 x milkshake @ £5.00\nTotal: £32.50\n"
      end

      it "confirms order, generates SMS confirmation, and returns itemised receipt" do
        Timecop.freeze(Time.local(2022, 6, 24)) do
          expect(@messenger).to receive(:send_notification).with("Thanks for your order! Estimated delivery time: 12:30 am").and_return("Thanks for your order! Estimated delivery time: 12:30 am")
          expect( @interface.confirm_order ).to eq "Order confirmation:\n2 x cheeseburger @ £9.50\n1 x fries @ £3.50\n2 x milkshake @ £5.00\nTotal: £32.50\n"
        end
      end
    end

    context "when items are removed from order" do
      it "returns updated order summary" do
        @interface.remove_item("cheeseburger")
        @interface.remove_item("fries")
        @interface.remove_item("milkshake", 2)
        allow(@order).to receive(:basket).and_return(
            {"cheeseburger" => 1}
        )
        expect( @interface.order_summary ).to eq "Order summary:\n1 x cheeseburger @ £9.50\nTotal: £9.50\n"
      end

      it "returns an error when removing an invalid quantity" do
        expect{ @interface.remove_item("cheeseburger", 0) }.to raise_error "Number of items must be greater than zero."
      end

      it "returns an error when removing an item not in order" do
        expect{ @interface.remove_item("soda") }.to raise_error "Item not found."
      end

      it "returns an error when removing more items than are in order" do
        expect{ @interface.remove_item("cheeseburger", 3) }.to raise_error "Cannot remove more items than have been added to order."
      end
    end
  end

  it "returns an error when adding item not on menu" do
    menu = double :menu
    expect(menu).to receive(:item_price).with("fries").and_return nil
    order = double :order
    messenger = double :notification_sender
    interface = Interface.new(menu, order, messenger)
    expect{ interface.add_item("fries") }.to raise_error "Item not found."
  end

  it "returns an error when adding invalid quantity" do
    menu = double :menu
    order = double :order
    messenger = double :notification_sender
    interface = Interface.new(menu, order, messenger)
    expect{ interface.add_item("cheeseburger", 0) }.to raise_error "Number of items must be greater than zero."
  end

  context "when no items have been added to order" do
    before(:example) do
      menu = double :menu
      order = double :order, basket: {}
      messenger = double :notification_sender
      @interface = Interface.new(menu, order, messenger)
    end

    it "returns an error when calling #order_summary on empty order" do
      expect{ @interface.order_summary }.to raise_error "Order not found."
    end

    it "returns an error when calling #confirm_order on empty order" do
      expect{ @interface.confirm_order }.to raise_error "Order not found."
    end
  end
end