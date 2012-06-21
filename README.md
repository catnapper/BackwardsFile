# BackwardsFile

Provides a class, BackwardsFile, that reads lines from a text file in reverse.
This is exactly what the more established 
[elif](http://elif.rubyforge.org) gem by James Edward Gray II does, but there 
are a few differences:

- BackwardsFile returns Enumerators that lazily read the file.
- The file is not held open.  The BackwardsFile object simply remembers its
	position in the file while iterating, and opens, reads, and closes the file
	as needed.

## Usage

There are several ways to use BackwardsFile.  The following are equivalent:

```ruby
BackwardsFile.open('textfile.txt') { |line| # code }
BackwardsFile.each('textfile.txt') { |line| # code }
```
	
If no code block is given, an Enumerator is returned that may be used like this:

```ruby
bf = BackwardsFile.open('textfile.txt')

# Iterate with Enumerator#next
last_line = bf.next
next_to_last_line = bf.next

# or use each
bf.each { |line| # do something with each line }
```
	
BackwardsFile includes Enumerable, so all the usual methods are available:

```ruby
BackwardsFile.open('logfile.log').find_all { |line| line =~ /pattern/ }
BackwardsFile.open('textfile.txt').take(10)
```

The BackwardsFile object may also be instantiated directly:

```ruby
bf = BackwardsFile.new 'textfile.txt'
```
	
and then iterated:

```ruby
bf.each { |line| # code }
```
	
A custom line separator may be specified with a Regexp as follows:

```ruby
BackwardsFile.open('textfile.txt', /sep_pattern/).each
```
	
or

```ruby
bf = BackwardsFile.new 'textfile.txt', /sep_pattern/
```
	
If a separator Regexp is not specified, a default one that recognizes both Unix
and Windows line endings is used.

### Exception Handling

BackwardsFile tags exceptions with the BackwardsFile::Error module, allowing
errors from within BackwardsFile to be caught explicitly like this:

```ruby
begin
  bf = BackwardsFile.open 'non-existant-file.txt'
rescue BackwardsFile::Error
  # handle error
end
```
	
The original exception is preserved, so the following code that captures the
error from the failed File#open operation inside of BackwardsFile will also 
work:

```ruby
begin
  bf = BackwardsFile.open 'non-existant-file.txt'
rescue Errno::ENOENT
  # handle error
end
```
