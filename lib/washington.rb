require "washington/version"
require "washington/example"
require "washington/formatter"
require "washington/failure"
require "washington/pending"
require "washington/success"

module Washington
  def self.list
    @@list ||= []
  end

  def self.use formatter
    @@formatter = formatter
  end

  def self.complete?
    not_run = @@picked.find_all do |example|
      example.is_a? Washington::Example
    end

    not_run.empty?
  end

  def self.picked
    @@picked ||= []
  end

  def self.picked= list
    @@picked = list
  end

  def self.successful
    @@picked.find_all do |example|
      example.is_a? Washington::Success
    end
  end

  def self.failing
    @@picked.find_all do |example|
      example.is_a? Washington::Failure
    end
  end

  def self.pending
    @@picked.find_all do |example|
      example.is_a? Washington::Pending
    end
  end

  def self.formatter
    @@formatter
  end

  def self.reset
    @@list   = nil
    @@picked = nil
    @@formatter = Washington::Formatter.new
  end
end
