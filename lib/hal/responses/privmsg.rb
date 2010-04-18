module Hal
  module Responses
    module Privmsg
      def on_privmsg
        return if response.pm?
        
        if response.text =~ /#{connection.nick}/i
          reply = Brain.speak
          privmsg(Brain.speak, response.channel) unless reply.nil? || reply.empty?
        else
          Brain.learn(response.text)
        end
      end
    end
  end
end
