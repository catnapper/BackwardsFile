require "backwardsfile/version"

class BackwardsFile
  include Enumerable
  BACKWARDS_CHUNK_SIZE = 4096

  module Error; end

  class << self
    def each *args, &block
      f = new *args
      f.each &block
    end
    alias_method :open, :each
  end

  # Returns a BackwardsFile object representing the lines of a text file with
  # the specified line separator.  The separator, if specified, must be a
  # Regexp.  The default regex recognizes both Unix and Windows line endings.
  #
  # The file must be readable when called.  Errors will be tagged with the
  # BackwardsFile::Error module.
  def initialize filename, separator = Regexp.new("[\r]?\n")
    File.open(filename, 'r') { |f| f.read(1) }
    @filename = filename
    @separator = separator
  rescue => err
    err.extend Error
    raise err
  end

  # Yields each line of the file, in reverse order, to the provided block.  If
  # no block is given, returns an Enumerator of file lines (Strings).
  def each
    block_given? ? lines.each { |l| yield l } : lines
  end

  private

  def read_chunk pos, read_size = BACKWARDS_CHUNK_SIZE
    [pos, File.open(@filename, 'r') { |f| f.seek(pos); f.read(read_size) }]
  end
  def first_chunk_backwards
    raise StopIteration unless pos = File.size?(@filename)
    read_size = (pos % BACKWARDS_CHUNK_SIZE) == 0 ? 
      BACKWARDS_CHUNK_SIZE : (pos % BACKWARDS_CHUNK_SIZE)
    pos -= read_size
    read_chunk pos, read_size
  end
  def next_chunk_backwards pos
    pos -= BACKWARDS_CHUNK_SIZE
    pos < 0 ? nil : read_chunk( pos )
  end
  # Returns an Enumerator that reads chunks of the file, starting from the end,
  # on demand (lazily).
  def chunks_backwards
    Enumerator.new do |yielder|
      pos, data = first_chunk_backwards
      yielder.yield data
      while result = next_chunk_backwards(pos) do
        pos, data = result
        yielder.yield data
      end
    end
  end
  # Provides an Enumerator that breaks chunks into lines
  def lines
    Enumerator.new do |yielder|
      begin
        buffer = ''
        chunks_backwards.each do |data|
          lines = (data + buffer).split(@separator)
          buffer = lines.shift
          lines.reverse.each { |line| yielder.yield line.gsub(@separator, '') }
        end
        yielder.yield buffer.gsub(@separator, '')
      rescue => err
        err.extend Error
        raise err
      end
    end
  end
end

