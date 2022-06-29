require "NotificationSender"

RSpec.describe NotificationSender do
  context "when message text provided" do
    before(:example) do
      client = double :client
      @message = double :message
      expect(client).to receive_message_chain(:messages, :create).and_return(@message)
      @messenger = NotificationSender.new(client)
    end
  
    it "sends SMS notification" do
      expect(@message).to receive(:error_code).and_return(nil)
      expect(@message).to receive(:body).and_return("hello world")
      expect( @messenger.send_notification("hello world") ).to eq "hello world"
    end

    it "fails if error code returned when sending SMS" do
      expect(@message).to receive(:error_code).and_return("0000")
      expect{ @messenger.send_notification("hello world") }.to raise_error "There was error sending SMS, please try again."
    end
  end

  it "fails if no message text provided" do
    client = double :client
    messenger = NotificationSender.new(client)
    expect{ messenger.send_notification("") }.to raise_error "No message provided."
  end
end