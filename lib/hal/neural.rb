module Hal
  class Brain
    include HTTParty
    base_uri "http://hal.blolol.com/brains"
    
    attr_reader :name, :connection
    
    def initialize(name)
      @name = name
      @connection = Wheaties::Connection.instance
    end
    
    def speak
      self.class.get("/#{name}.txt")
    end
    
    def learn(text)
      self.class.put("/#{name}.txt", :body => { :text => text })
    end
    
    def feed(text)
      if text =~ /#{connection.nick}/i
        speak
      else
        learn(text)
        nil
      end
    end
    
    class << self
      def speak
        new(Hal.config["brain"]).speak
      end
      
      def learn(text)
        new(Hal.config["brain"]).learn(text)
      end
      
      def feed(response)
        new(Hal.config["brain"]).feed(response)
      end
    end
  end
end
