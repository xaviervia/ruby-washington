module Washington
  class Success
    attr_reader :message, :function, :original

    def initialize message, function, original
      @message = message
      @function = function
      @original = original
    end
  end
end
