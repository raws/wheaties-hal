module Hal
  class Message
    attr_reader :conversation, :text, :time
    
    def initialize(conversation, text)
      @conversation = conversation
      @text = text
      @time = Time.now
    end
  end
end
