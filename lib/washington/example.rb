require "washington"

module Washington
  class Example
    attr_accessor :message, :function

    def initialize message = nil, function = nil
      @message = message
      @function = function

      Washington.list.push self
      Washington.picked = Washington.list
    end

    def run
      return pending if @function.nil?

      begin
        @function.call
        success
      rescue Exception => error
        failed error
      end
    end

    def failed error
      failure = Failure.new @message, @function, self, error

      Washington.picked.map! do |example|
        if example == self
          failure
        else
          example
        end
      end

      failure
    end

    def pending
      pending = Pending.new @message, self

      Washington.picked.map! do |example|
        if example == self
          pending
        else
          example
        end
      end

      pending
    end

    def success
      success = Success.new @message, @function, self

      Washington.picked.map! do |example|
        if example == self
          success
        else
          example
        end
      end

      success
    end
  end
end
