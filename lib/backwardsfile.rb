require "backwardsfile/version"

class BackwardsFile

  include Enumerable

  Error = Module.new
  BACKWARDS_CHUNK_SIZE = 4096

  class << self
    alias_method :open, :new
  end

  attr_reader :separator, :chunk_size, :io, :owned

  def initialize args
    tag_errors do
      @io = args.fetch(:io) do |k|
        @owned = true
        File.open(args.fetch(:filename), 'r')
      end
      @separator = args.fetch(:separator, $/)
      @chunk_size = args.fetch(:chunk_size, BACKWARDS_CHUNK_SIZE)
      set_up_io
    end
  end

  def tag_errors err_mod = Error
    yield
  rescue => e
    e.extend err_mod
    raise
  end

  def set_up_io io_object = io
    io_object.seek(0, IO::SEEK_END)
    io_object
  end

  def next_chunk_size
    (io.pos % chunk_size) == 0 ? chunk_size : (io.pos % chunk_size)
  end

  def next_chunk size = next_chunk_size
    start_pos = io.pos - size
    raise EOFError if start_pos < 0
    io.pos = start_pos
    chunk = io.read size
    io.pos = start_pos
    chunk
  end

  def with_each_line
    tag_errors do
      line_regexp = Regexp.new(".*?#{Regexp.escape(separator)}|.+")
      buffer = []
      until io.pos == 0 do
        buffer = (next_chunk + (buffer.first || '')).scan(line_regexp)
        yield buffer.pop while buffer.length > 1
      end
      yield buffer.pop until buffer.length == 0
    end
  ensure
    io.close if owned
  end

  def each &block
    block ? with_each_line(&block) : enum_for(:with_each_line)
  end

end

