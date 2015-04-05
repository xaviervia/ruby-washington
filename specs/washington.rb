a = File.absolute_path(__FILE__).split "/"
a.pop 2
$:.unshift a.join("/") + "/lib"

require "washington/global"

CLEAR      = "\e[0m"
BOLD       = "\e[1m"

def log text
  puts BOLD + text + CLEAR
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
