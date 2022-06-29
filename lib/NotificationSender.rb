require "twilio-ruby"
require "dotenv/load"

$test_number = ENV["MOBILE_NUMBER"]

class NotificationSender
  def initialize(client)
    @client = client
  end

  def send_notification(text)
    fail "No message provided." if text == ""
    message = @client.messages.create(
      body: text,
      to: $test_number,
      from: "+15005550006"
    )
    fail "There was error sending SMS, please try again." unless message.error_code == nil
    # puts message.body
    return message.body
  end
end