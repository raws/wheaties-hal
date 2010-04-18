module Hal
  module Responses
    module Messages
      def on_privmsg
        privmsg(Brain.speak, response.channel) if reply?
        Brain.learn(response.text) if learn?
      end
      
      def on_action
        privmsg(Brain.speak, response.channel) if reply?
      end
      
      protected
        def reply?
          reply = !response.pm?
          reply = reply && response.text =~ /#{connection.nick}/i
          reply = reply && response.text !~ /^[!\.]/
          
          if Hal.config["replies"] && Hal.config["replies"]["only"]
            reply = reply && Hal.config["replies"]["only"].find do |nick|
              response.sender.to_s =~ wildcard(nick)
            end
          end
          
          if Hal.config["replies"] && Hal.config["replies"]["except"]
            reply = reply && !Hal.config["replies"]["except"].find do |nick|
              response.sender.to_s =~ wildcard(nick)
            end
          end
          
          reply
        end
        
        def learn?
          learn = !response.pm?
          learn = learn && response.sender.nick != connection.nick
          learn = learn && response.text !~ /^[!\.]/
          
          if Hal.config["learns"] && Hal.config["learns"]["only"]
            learn = learn && Hal.config["learns"]["only"].find do |nick|
              response.sender.to_s =~ wildcard(nick)
            end
          end
          
          if Hal.config["learns"] && Hal.config["learns"]["except"]
            learn = learn && !Hal.config["learns"]["except"].find do |nick|
              response.sender.to_s =~ wildcard(nick)
            end
          end
          
          learn
        end
        
        def wildcard(string)
          /^\s*#{string.strip.gsub("*", ".*")}\s*$/i
        end
    end
  end
end
