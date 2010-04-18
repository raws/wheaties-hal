module Hal
  class Conversation
    include Comparable
    include Wheaties::Concerns::Messaging
    
    SECONDS_UNTIL_CONVO_OVER = 5
    CHANCE_CONVO_CONTINUES = 0.75
    
    attr_reader :channel, :nick, :messages
    
    def initialize(channel, nick)
      @channel = channel
      @nick = nick
      @messages = []
    end
    
    def <<(message)
      messages << Message.new(self, message)
    end
    
    def old?
      !messages.empty? && (Time.now - messages.last.time > SECONDS_UNTIL_CONVO_OVER)
    end
    
    def age
      messages.last.time - messages[-2].time if messages.size >= 2
    end
    
    def continue?
      rand <= CHANCE_CONVO_CONTINUES
    end
    
    def converse!
      return if messages.empty?
      
      if messages.last.text =~ /#{Wheaties::Connection.nick}/i ||
         (messages.size >= 2 && age < SECONDS_UNTIL_CONVO_OVER && continue?)
        privmsg(Brain.speak, channel)
      end
    end
    
    def delete!
      Conversation.all.delete(self)
    end
    
    def <=>(other)
      other.channel == channel && other.nick == nick
    end
    
    class << self
      include Wheaties::Concerns::Normalization
      
      def all
        Consciousness.instance.conversations
      end
      
      def find(channel, nick)
        channel = normalize(channel)
        nick = normalize(nick)
        all.find do |conversation|
          conversation.channel == channel && conversation.nick == nick
        end
      end
      
      def create(channel, nick)
        conversation = new(normalize(channel), normalize(nick))
        Consciousness << conversation
        conversation
      end
      
      def find_or_create(channel, nick)
        find(channel, nick) || create(channel, nick)
      end
      
      def purge!
        all.delete_if { |conversation| conversation.old? }
      end
    end
  end
end
