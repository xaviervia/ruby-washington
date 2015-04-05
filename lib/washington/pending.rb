module Washington
  class Pending
    attr_reader :message, :original
    
    def initialize message, original
      @message = message
      @original = original
    end
  end
end
