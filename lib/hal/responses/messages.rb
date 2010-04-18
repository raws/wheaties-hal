module Hal
  module Responses
    module Messages
      def on_privmsg
        return if response.pm? || response.sender.nick == connection.nick
        if reply = Brain.feed(response.text)
          privmsg(reply, response.channel)
        end
      end
      
      alias :on_action :on_privmsg
    end
  end
end
