require "singleton"

module Hal
  class Consciousness
    include Singleton
    
    attr_reader :conversations
    
    def initialize
      @conversations = Set.new
    end
    
    class << self
      def <<(conversation)
        self.instance.conversations << conversation
      end
      
      def update(channel, nick, message)
        Conversation.purge!
        
        if message =~ /#{Wheaties::Connection.nick}/i
          conversation = Conversation.find_or_create(channel, nick)
        else
          conversation = Conversation.find(channel, nick)
        end
        
        if conversation
          conversation << message
          conversation.converse!
        end
      end
    end
  end
end
