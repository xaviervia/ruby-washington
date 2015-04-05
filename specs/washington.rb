a = File.absolute_path(__FILE__).split "/"
a.pop 2
$:.unshift a.join("/") + "/lib"

require "pry"
require "washington/global"

CLEAR      = "\e[0m"
BOLD       = "\e[1m"

def log text
  puts BOLD + text + CLEAR
end

def cleanup!
  Washington.reset
end

log "Washington"
log "=========="
log ""

#############################################################################

log "Calling the function should get back an instance"

the_example = example()

unless the_example.is_a? Washington::Example
  raise "it should be a Washington::Example"
end

cleanup!

#############################################################################

log "The message should be stored in the instance"

the_example = example "Message"

unless the_example.message == "Message"
  raise "The message should be stored"
end

cleanup!

#############################################################################

log "The example proc should also be stored"

example_proc = proc {}
the_example = example "The message", example_proc

unless the_example.function == example_proc
  raise "The proc should be stored"
end

cleanup!

#############################################################################

log "The example should be registered in the list"

the_example = example "Registered"

unless Washington.list.include? the_example
  raise "The example should be registered"
end

cleanup!

#############################################################################

log "The example should change itself to a Success when successful"

Washington.use "silent"

example_proc = proc { raise "fail" unless 2 + 2 == 4 }
the_example = example "To the infinite and beyond!", example_proc

success = the_example.run

unless Washington.picked[0].is_a? Washington::Success
  binding.pry
  raise "It should convert to a success"
end

unless Washington.picked[0].message == "To the infinite and beyond!"
  raise "The success should contain the message"
end

unless Washington.picked[0].function == example_proc
  raise "The success should contain the function"
end

unless Washington.picked[0].original == the_example
  raise "The success should contain the original example"
end

unless Washington.picked[0] == success
  raise "The return of #run should be the same Success instance"
end

unless Washington.picked[0] == Washington.successful[0]
  raise "The success should be available on the #successful list"
end

cleanup!

#############################################################################

log "The example should change itself to a Failure when failing"

Washington.use "silent"

example_proc = proc { raise ArgumentError, "no bueno" unless 2 + 3 == 4 }
the_example = example "To the failure and beyond!", example_proc

failure = the_example.run

unless Washington.picked[0].is_a? Washington::Failure
  raise "It should be a Failure"
end

unless Washington.picked[0].message == "To the failure and beyond!"
  raise "It should have the message"
end

unless Washington.picked[0].error.is_a? ArgumentError
  raise "It should have the error"
end

unless Washington.picked[0].error.message == "no bueno"
  raise "The error should have the message"
end

unless Washington.picked[0].function == example_proc
  raise "It should have the proc"
end

unless Washington.picked[0].original == the_example
  raise "It should have the original"
end

unless Washington.picked[0] == failure
  raise "It should return the failure"
end

unless Washington.failing[0] == Washington.picked[0]
  raise "It should be in the failing list"
end

cleanup!

#############################################################################

log "The example should change itself to a Pending when there is no function"

Washington.use "silent"

the_example = example "This is not defined yet"

pending = the_example.run

unless Washington.picked[0].is_a? Washington::Pending
  raise "It should be a Pending"
end

unless Washington.picked[0].message == "This is not defined yet"
  raise "It should have the message"
end

unless Washington.picked[0].original == the_example
  raise "It should have the original"
end

unless Washington.picked[0] == pending
  raise "It should return the picked"
end

unless Washington.pending[0] == Washington.picked[0]
  raise "It should be in the pending list"
end

cleanup!

#############################################################################

log "By default the formatter should be set as formatter"

unless Washington.formatter.is_a? Washington::Formatter
  raise "It should use the default formatter"
end

cleanup!

#############################################################################

log "You should be able to replace the formatter by a different one"

a_formatter = Object.new

Washington.use a_formatter

unless Washington.formatter == a_formatter
  raise "It should be the new formatter"
end

cleanup!


#############################################################################

log "It is not complete if there are examples not done"

Washington.picked = [Washington::Example.new]

if Washington.complete?
  raise "It shouldn't be complete"
end

cleanup!
