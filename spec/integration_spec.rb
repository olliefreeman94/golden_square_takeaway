require "Interface"
require "Menu"
require "Item"
require "Order"
require "NotificationSender"
require "dotenv/load"

account_sid = ENV["TWILIO_ACCOUNT_SID"]
auth_token = ENV["TWILIO_AUTH_TOKEN"]
$client = Twilio::REST::Client.new(account_sid, auth_token)

RSpec.describe "integration" do
  before(:example) do
    item1 = Item.new("cheeseburger", 9.5)
    item2 = Item.new("fries", 3.5)
    item3 = Item.new("milkshake", 5)
    menu = Menu.new
    menu.add(item1)
    menu.add(item2)
    menu.add(item3)
    order = Order.new
    messenger = NotificationSender.new($client)
    @interface = Interface.new(menu, order, messenger)
  end

  it "lists all menu items and prices" do
    expect( @interface.list_menu ).to eq "cheeseburger: £9.50\nfries: £3.50\nmilkshake: £5.00\n"
  end

  context "when items have been added to order" do
    before(:example) do
      @interface.add_item("cheeseburger", 2)
      @interface.add_item("fries")
      @interface.add_item("milkshake", 2)
    end

    it "returns order summary" do
      expect( @interface.order_summary ).to eq "Order summary:\n2 x cheeseburger @ £9.50\n1 x fries @ £3.50\n2 x milkshake @ £5.00\nTotal: £32.50\n"
    end

    it "confirms order, generates SMS confirmation, and returns itemised receipt" do
      expect( @interface.confirm_order ).to eq "Order confirmation:\n2 x cheeseburger @ £9.50\n1 x fries @ £3.50\n2 x milkshake @ £5.00\nTotal: £32.50\n"
    end

    context "when items are removed from order" do
      it "returns updated order summary" do
        @interface.remove_item("cheeseburger")
        @interface.remove_item("fries")
        @interface.remove_item("milkshake", 2)
        expect( @interface.order_summary ).to eq "Order summary:\n1 x cheeseburger @ £9.50\nTotal: £9.50\n"
      end
    end
  end
end