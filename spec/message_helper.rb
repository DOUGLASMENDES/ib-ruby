require 'spec_helper'
require 'thread'
require 'stringio'

# Given an IB message, retuns its type Symbol (e.g. :OpenOrderEnd)
def message_type msg
  msg.class.to_s.split(/::/).last.to_sym
end

def print_subject
  it 'prints out message' do
    p subject
    p subject.to_human
  end
end

alias ps print_subject

## Logger helpers

def mock_logger
  @stdout = StringIO.new

  @logger = Logger.new(@stdout).tap do |logger|
    logger.formatter = proc do |level, time, prog, msg|
      "#{time.strftime('%H:%M:%S.%N')} #{msg}\n"
    end
    logger.level = Logger::INFO
  end
end

def log_entries
  @stdout && @stdout.string.split(/\n/)
end

def should_log *patterns
  patterns.each do |pattern|
    log_entries.any? { |entry| entry =~ pattern }.should be_true
  end
end

def should_not_log *patterns
  patterns.each do |pattern|
    log_entries.any? { |entry| entry =~ pattern }.should be_false
  end
end

## Connection helpers

def connect_and_receive *message_types

  # Start disconnected (we need to set up catch-all subscriber first)
  @ib = IB::Connection.new CONNECTION_OPTS.merge(:connect => false,
                                                 :reader => false,
                                                 :logger => mock_logger)

  # Hash of received messages, keyed by message type
  @received = Hash.new { |hash, key| hash[key] = Array.new }

  # Catch all messages of given types and put them inside @received Hash
  @ib.subscribe(*message_types) { |msg| @received[message_type(msg)] << msg }

  @ib.connect
  @ib.start_reader
end

# Clear logs and message collector. Output may be silenced
def clean_connection
  unless SILENT
    puts @received.map { |type, msg| [" #{type}:", msg.map(&:to_human)] }
    puts " Logs:"
    puts log_entries
  end
  @stdout.string = '' if @stdout
  @received.clear if @received
end

def close_connection
  @ib.close if @ib
  clean_connection
end

#noinspection RubyArgCount
def wait_for time = 1, &condition
  timeout = Time.now + time
  sleep 0.1 until timeout < Time.now || condition && condition.call
end

def received? symbol
  not @received[symbol].empty?
end
