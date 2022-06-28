require "Interface"
require "Menu"
require "Item"

RSpec.describe "integration" do
  before(:example) do
    item1 = Item.new("cheeseburger", 9.5)
    item2 = Item.new("fries", 3.5)
    item3 = Item.new("milkshake", 5)
    menu = Menu.new
    menu.add(item1)
    menu.add(item2)
    menu.add(item3)
    @interface = Interface.new(menu)
  end

  it "lists all menu items and prices" do
    expect( @interface.list_menu ).to eq "cheeseburger: £9.50\nfries: £3.50\nmilkshake: £5.00\n"
  end

  xit "adds items to order, and returns order summary" do
    @interface.add_item("cheeseburger", 2)
    @interface.add_item("fries")
    @interface.add_item("milkshake", 2)
    expect( @interface.order_summary ).to eq "Order summary:\n2 x cheeseburger @ £9.50\n1 x fries @ £3.50\n2 x milkshake @ £5.00\nTotal: £32.50\n"
  end
end