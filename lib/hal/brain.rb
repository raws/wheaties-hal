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
    
    def delete!
      self.class.delete("/#{name}.txt")
    end
    
    class << self
      def speak
        new(Hal.config["brain"]).speak
      end
      
      def learn(text)
        new(Hal.config["brain"]).learn(text)
      end
    end
  end
end
