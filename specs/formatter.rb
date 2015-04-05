a = File.absolute_path(__FILE__).split "/"
a.pop 2
$:.unshift a.join("/") + "/lib"

require "washington/formatter"

red        = "\e[31m"
green      = "\e[32m"
yellow     = "\e[33m"
clear      = "\e[0m"
bold       = "\e[1m"
grey       = "\e[30m"

module Mock
  class Printer
    attr_reader :flag

    def initialize expected
      @expected = expected
    end

    def write text
      unless text == @expected
        raise "The text is different than expected"
      end

      @flag = true
    end

    def flag
      @flag
    end
  end

  class Example
    attr_reader :message, :duration, :error

    def initialize message = nil, duration = nil, error = nil
      @message = message
      @duration = duration
      @error = error
    end
  end
end

def log text
  puts "\e[1m" + text + "\e[0m"
end

log ""
log "Run formatter tests"
log "-------------------"
log ""

#############################################################################

log "stdout is $stdout"

formatter = Washington::Formatter.new

raise "Should be $stdout" unless formatter.stdout == $stdout

#############################################################################

log "stderr is $stderr"

formatter = Washington::Formatter.new

raise "Should be $stderr" unless formatter.stderr == $stderr


#############################################################################

log "argument replaces stdout"

stdout = Object.new

formatter = Washington::Formatter.new stdout

raise "Should be the argument stdout" unless formatter.stdout == stdout

#############################################################################

log "argument replaces stderr"

stderr = Object.new

formatter = Washington::Formatter.new nil, stderr

raise "Should be the argument stderr" unless formatter.stderr == stderr

#############################################################################

log "Should log to stdout in green and nice whenever a success occurs and duration in grey"


message = "This will succeed"

formatter = Washington::Formatter.new(
  Mock::Printer.new "\e[32m ✌ #{message}\e[0m\e[30m (34ms)\e[0m\n"
)

formatter.success Mock::Example.new message, 34

unless formatter.stdout.flag
  raise "The #write method wasn't executed"
end

#############################################################################

log "Should log to warn in yellow and normal whenever a pending occurs"

message = "This is pending"

formatter = Washington::Formatter.new(
  nil, Mock::Printer.new("\e[33m ✍ #{message}\e[0m\n")
)

formatter.pending Mock::Example.new message

unless formatter.stderr.flag
  raise "The #write method wasn't executed"
end

#############################################################################

log "Should log to error in red with the shortened stack whenever a failure occurs and duration in grey"

message      = "This fails"
# error        =
#   stack: "Error: FAIL\n
#   at null.function (/Users/fernando.canel/Code/remote/washington/examples/asyncFailSync.js:4:9)\n
#   at Washington.Example.run (/Users/fernando.canel/Code/remote/washington/washington.js:847:24)\n
#   at Function.Washington.go (/Users/fernando.canel/Code/remote/washington/washington.js:624:31)\n
#   at Object.<anonymous> (/Users/fernando.canel/Code/remote/washington/examples/asyncFailSync.js:8:12)\n
#   at Module._compile (module.js:444:26)\n
#   at Object.Module._extensions..js (module.js:462:10)\n
#   at Module.load (module.js:339:32)\n
#   at Function.Module._load (module.js:294:12)\n
#   at Function.Module.runMain (module.js:485:10)\n
#   at startup (node.js:112:16)"
#
# shortened    = "Error: FAIL\n
# at null.function (/Users/fernando.canel/Code/remote/washington/examples/asyncFailSync.js:4:9)"

formatter = Washington::Formatter.new(
  nil, nil #Mock::Printer.new(
  #   "\e[31m ☞ #{message}\e[0m\e[30m (56ms)\e[0m\e[31m\n" +
  #   " ☞ #{short.stack}\e[0m\n"
  # )
)

formatter.failure Mock::Example.new message, 56, Exception.new
