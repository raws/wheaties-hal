module Hal
  class << self
    attr_accessor :config
    
    def start
      load_defaults
    end
    
    def load_defaults
      brain_config_path = Wheaties.root.join("config/brain.yml")
      Hal.config = YAML.load_file(brain_config_path) || {}
    end
  end
  
  self.start
end
