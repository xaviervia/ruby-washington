module Washington
  class Failure
    attr_reader :message, :function, :original, :error

    def initialize message, function, original, error
      @message = message
      @function = function
      @original = original
      @error = error
    end
  end
end
