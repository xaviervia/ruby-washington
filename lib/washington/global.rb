require "washington"

module Washington
  module Global
    def example message = nil, function = nil
      Washington::Example.new message, function
    end
  end
end

include Washington::Global
