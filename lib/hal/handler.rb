module Hal
  class Handler < Wheaties::Handler
    include Hal::Responses::Messages
  end
end
