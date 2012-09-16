require 'stringio'
require 'digest/md5'


class BackwardsFile
  attr_accessor :buffer_size

  def chunk_size
    1024
  end
  def initialize file, min_buffer_size = (chunk_size * 2)
    @file = file.respond_to?(:read) ? file : File.open(file)
    buffer_size = min_buffer_size
  end
  def close
    @file.close if @file.respond_to?(:close)
  end
  def read_chunk pos = @file.pos, size = CHUNK_SIZE
    if pos < 0
      size = size + pos
      @file.pos = 0
    else
      @file.pos = pos
    end
    @file.read(size)
  end
end


describe BackwardsFile do

  def create_random_file
    buffer = StringIO.new
    digest =  Digest::MD5.new
    1000.times do |n|
      digest << n.to_s
      buffer.puts digest.hexdigest
    end
    buffer
  end

  let(:testfile) { create_random_file }
  let(:bf) { BackwardsFile.new(testfile) }

  it 'can read the entire file in one chunk' do
    bf.read_chunk(0, testfile.size).should == testfile.string
  end

  it 'can read an arbitrarily sized chunk from the file' do
    expected = testfile.each_line.take(20).join("\n")
    bf.read_chunk(0, expected.length).should == expected
  end
  
  it 'reads an appropriately sized chunk when given a negative position' do
    bf.read_chunk(-1, 21).should == testfile.string[0...20]
  end

end
