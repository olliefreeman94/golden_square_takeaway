require "Item"

RSpec.describe Item do
  it "returns item name and price" do
    item = Item.new("cheeseburger", 9.5)
    expect( item.name ).to eq "cheeseburger"
    expect( item.price ).to eq 9.5
  end
end