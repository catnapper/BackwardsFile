require 'stringio'
require 'tempfile'
require 'minitest/spec'
require 'minitest/autorun'

describe BackwardsFile do

  describe 'internal implementation' do

    before do
      @testio = StringIO.new('!asdfasdf')
      @bf = BackwardsFile.new io: @testio, chunk_size: 4
    end

    it 'sets the IO pos to end of the file' do
      assert_equal @testio.size, @bf.io.pos
    end

    it 'determines the correct size for the first chunk' do
      assert_equal 1, @bf.next_chunk_size
    end

    it 'can read a chunk from the file' do
      assert_equal 'asdf', @bf.next_chunk(4)
    end

    it 'reads chunks sequentially starting at end of file' do
      assert_equal 'f', @bf.next_chunk
      assert_equal 'fasd', @bf.next_chunk
      assert_equal '!asd', @bf.next_chunk
    end

  end

  describe '#each' do

    before do
      @data = "line1\nline2\nline3\nline4"
      @testio = StringIO.new(@data)
      @bf = BackwardsFile.new io: @testio, chunk_size: 4, separator: "\n"
    end

    it '#each returns an enumerator' do
      assert_kind_of Enumerator, @bf.each
    end

    it 'returns an empty enumerator when given a zero length file' do
      io = StringIO.new('')
      assert_equal 0, BackwardsFile.new(io: io).each.count
    end

    it 'returns lines in reverse order' do
      result = ["line4", "line3\n", "line2\n", "line1\n"]
      assert_equal result, @bf.each.to_a
    end

  end

  it 'can be initialized with a filename' do
    bf = BackwardsFile.new filename: Tempfile.new('test').path
    assert_kind_of IO, bf.io
  end

  it 'closes ios that it owns after iterating' do
    bf = BackwardsFile.new filename: Tempfile.new('test').path
    bf.each.to_a
    assert bf.io.closed?
  end

  it 'implements the open class method as an alias for new' do
    bf = BackwardsFile.open filename: Tempfile.new('test').path
    assert_kind_of IO, bf.io
  end

  it 'does not close ios given to it' do
    bf = BackwardsFile.new io: StringIO.new('test')
    bf.each.to_a
    refute bf.io.closed?
  end

end
