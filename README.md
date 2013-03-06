# BackwardsFile

Provides a class, BackwardsFile, that reads lines from a text file in reverse order. 

## Basic Usage

BackwardsFile is instantiated with keyword parameters.  One of either `io` or `filename` must be specified.  For example:

```ruby
file_io = File.open('testfile.txt', 'r')
bf1 = BackwardsFile.new io: file_io

# does the same thing, but opens and closes the file for you
# The open class method is an alias for new
bf2 = BackwardsFile.open filename: testfile.txt
```

In the case where the filename is specified, BackwardsFile will open the file during initialization, and close it when the `#each` method has finished iteration.  If the `io` parameter is used, you are responsible for opening and closing the file.

BackwardsFile implements an `#each` method that either passes lines to the given block, or returns an enumerator if no block is given:  

```ruby
# pass a block
BackwardsFile.new(filename: 'testfile.txt').each { |line| # code }

# or get an enumerator for external iteration
bf = BackwardsFile.new(filename: 'testfile.txt').each
puts bf.next
puts bf.next # etc
```
	
BackwardsFile includes Enumerable, so all the usual methods are available:

```ruby
BackwardsFile.new(filename: 'logfile.log').find_all { |line| line =~ /pattern/ }
BackwardsFile.new(filename: 'textfile.txt').take(10)
```

## Other Options

The default line separator is system defined.  A custom one may be specified by passing a string as the `separator` parameter:

```ruby
# use pipe as the line separator
BackwardsFile.new(filename: 'a_file', separator: '|').each { |line| ... }
```

Internally BackwardsFile manages a buffer that reads pieces of the file in an on-demand fashion.  By default, these reads are 4Kib in size.  This may be changed by specifying the read size, in bytes, with the `chunk_size` parameter.
	
### Exception Handling

BackwardsFile tags exceptions with the BackwardsFile::Error module, allowing
errors from within BackwardsFile to be caught explicitly like this:

```ruby
begin
  bf = BackwardsFile.new filename: 'non-existant-file.txt'
rescue BackwardsFile::Error
  # handle error
end
```
