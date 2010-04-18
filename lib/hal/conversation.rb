module Hal
  class Conversation
    include Comparable
    include Wheaties::Concerns::Messaging
    
    CHANCE_CONVO_CONTINUES = { 0..2.5 => 1, 2.5..4 => 0.75, 4..6 => 0.33, 6..10 => 0.15 }
    
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
      !messages.empty? && (Time.now - messages.last.time > CHANCE_CONVO_CONTINUES.keys.last.end)
    end
    
    def continue?
      if messages.size >= 2
        age = messages.last.time - messages[-2].time
        rand < (CHANCE_CONVO_CONTINUES.find_in_range(age) || 0)
      else
        false
      end
    end
    
    def converse!
      return if messages.empty?
      
      if messages.last.text =~ /#{Wheaties::Connection.nick}/i || continue?
        privmsg(Brain.speak, channel)
      end
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
