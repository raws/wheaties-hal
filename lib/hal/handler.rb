module Hal
  class Handler < Wheaties::Handler
    include Hal::Responses::Privmsg
  end
end
