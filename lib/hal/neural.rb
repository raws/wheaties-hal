module Hal
  class Brain
    include HTTParty
    base_uri "http://hal.blolol.com/brains"
    
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
    
    def speak
      self.class.get("/#{name}.txt")
    end
    
    def learn(text)
      response = self.class.put("/#{name}.txt", :body => { :text => text })
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
