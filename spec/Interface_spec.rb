require "Interface" 

RSpec.describe Interface do
  it "lists all menu items and prices" do
    menu = double :menu, all: [{:name => "cheeseburger", :price => 9.5}, {:name => "fries", :price => 3.5}, {:name => "milkshake", :price => 5}]
    interface = Interface.new(menu)
    expect( interface.list_menu ).to eq "cheeseburger: £9.50\nfries: £3.50\nmilkshake: £5.00\n"
  end

  it "returns an error with an empty menu" do
    menu = double :menu, all: []
    interface = Interface.new(menu)
    expect{ interface.list_menu }.to raise_error "No menu found."
  end

  xit "add items to order, and returns order summary" do
    menu = double :menu
    allow(menu).to receive(:item_price).with("cheeseburger").and_return(9.5)
    allow(menu).to receive(:item_price).with("fries").and_return(9.5)
    allow(menu).to receive(:item_price).with("milkshake").and_return(5)
    interface = Interface.new(menu)
    interface.add_item("cheeseburger", 2)
    interface.add_item("fries")
    interface.add_item("milkshake", 2)
    expect( interface.order_summary ).to eq "Order summary:\n2 x cheeseburger @ £9.50\n1 x fries @ £3.50\n2 x milkshake @ £5.00\nTotal: £32.50\n"
  end

  it "returns an error when adding item not on menu" do
    menu = double :menu
    allow(menu).to receive(:item_price).with("fries").and_return nil
    interface = Interface.new(menu)
    expect{ interface.add_item("fries") }.to raise_error "Item not found."
  end

  it "returns an error when adding invalid quantity" do
    menu = double :menu
    allow(menu).to receive(:item_price).with("cheeseburger").and_return 9.5
    interface = Interface.new(menu)
    expect{ interface.add_item("cheeseburger", 0) }.to raise_error "Number of items must be greater than zero."
  end
end