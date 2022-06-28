require "Menu"

RSpec.describe Menu do
  context "when items have been added to menu" do
    before(:example) do
      item1 = double :item, name: "cheeseburger", price: 9.5
      item2 = double :item, name: "milkshake", price: 5
      @menu = Menu.new
      @menu.add(item1)
      @menu.add(item2)
    end

    it "lists all items and prices" do
      expect( @menu.all ).to eq [{:name => "cheeseburger", :price => 9.5}, {:name => "milkshake", :price => 5}]
    end

    it "returns item price" do
      expect( @menu.item_price("cheeseburger") ).to eq 9.5
    end

    it "returns nil if item not on menu" do
      expect( @menu.item_price("soda") ).to eq nil
    end
  end

  context "when no items have been added to menu" do
    it "returns an empty list" do
      menu = Menu.new
      expect( menu.all ).to eq []
    end
  end
end