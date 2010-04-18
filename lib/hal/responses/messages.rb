module Hal
  module Responses
    module Messages
      def on_privmsg
        Consciousness.update(response.channel, response.sender.nick, response.text) if converse?
        Brain.learn(response.text) if learn?
      end
      
      def on_action
        Consciousness.update(response.channel, response.sender.nick, response.text) if converse?
      end
      
      protected
        def converse?
          converse = !response.pm?
          converse = converse && response.text !~ /^[!\.]/
          
          if Hal.config["converses"] && Hal.config["converses"]["only"]
            converse = converse && Hal.config["converses"]["only"].find do |nick|
              response.sender.to_s =~ wildcard(nick)
            end
          end
          
          if Hal.config["converses"] && Hal.config["converses"]["except"]
            converse = converse && !Hal.config["converses"]["except"].find do |nick|
              response.sender.to_s =~ wildcard(nick)
            end
          end
          
          converse
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
