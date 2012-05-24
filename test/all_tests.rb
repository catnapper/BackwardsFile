require 'minitest/autorun'

TEST_FILES = Dir['test/tmp/*.txt']

class TestAll < MiniTest::Unit::TestCase
	def setup
		@desired_result = IO.readlines('test/tmp/testfile_lf.txt').map do |l|
			l.strip
		end.reverse
	end
	def test_each_method_returns_enumerator
		assert_kind_of Enumerator, BackwardsFile.new(TEST_FILES.first).each
	end
	def test_class_method_open_returns_enumerator
		assert_kind_of Enumerator, BackwardsFile.open(TEST_FILES.first)
	end
	def test_class_method_each_returns_enumerator
		assert_kind_of Enumerator, BackwardsFile.each(TEST_FILES.first)
	end
	def test_class_method_each_accepts_block
		assert_equal @desired_result, 
			BackwardsFile.each('test/tmp/testfile_lf.txt').to_a
	end
	def test_each_accepts_block
		assert_equal @desired_result,
			BackwardsFile.new('test/tmp/testfile_lf.txt').each.to_a
	end
	def test_crlf_file
		assert_equal @desired_result,
			BackwardsFile.each('test/tmp/testfile_crlf.txt').to_a
	end
	def test_custom_separator
		bf = BackwardsFile.new 'test/tmp/testfile_q.txt', /q/
		assert_equal @desired_result, bf.each.to_a
	end
end
