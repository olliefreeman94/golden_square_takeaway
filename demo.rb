require "./lib/Interface.rb"
require "./lib/Menu.rb"
require "./lib/Item.rb"
require "./lib/Order.rb"
require "./lib/NotificationSender.rb"
require "dotenv/load"

account_sid = ENV["TWILIO_ACCOUNT_SID"]
auth_token = ENV["TWILIO_AUTH_TOKEN"]
client = Twilio::REST::Client.new(account_sid, auth_token)

item1 = Item.new("cheeseburger", 9.5)
item2 = Item.new("fries", 3.5)
item3 = Item.new("milkshake", 5)
menu = Menu.new
menu.add(item1)
menu.add(item2)
menu.add(item3)
order = Order.new
messenger = NotificationSender.new(client)
interface = Interface.new(menu, order, messenger)

puts "It returns list menu items and prices:"
puts interface.list_menu


interface.add_item("cheeseburger", 2)
interface.add_item("fries")
interface.add_item("milkshake", 2)

puts "After items added to order, it returns itemised order summary:"
puts interface.order_summary

puts "After order confirmed, it sends SMS with estimated delivery time, and returns itemised order confirmation:"
# puts messenger.send_notification("Thanks for your order! Estimated delivery time: XX:XX pm")
puts interface.confirm_order