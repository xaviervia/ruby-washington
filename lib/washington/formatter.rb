module Washington
  class Formatter
    attr_accessor :stdout, :stderr

    def initialize stdout = nil, stderr = nil
      @stdout = stdout || $stdout
      @stderr = stderr || $stderr
    end

    def success success
      @stdout.write "\e[32m ✌ #{success.message}\e[0m\e[30m (#{success.duration}ms)\e[0m\n"
    end

    def pending pending
      @stderr.write "\e[33m ✍ #{pending.message}\e[0m\n"
    end

    def failure failure
      binding.pry
      @stderr.write "\e[31m ☞ #{failure.message}\e[0m\e[30m" +
        " (#{failure.duration}ms)\e[0m\e[31m\n ☞ " +
        "#{failure.error.backtrace}\e[0m\n"
    end
  end
end
