require 'readline'

class MyFile
   attr_reader :handle

   def initialize(filename)
     @handle = File.open(filename, "r")
   end

   def finished
     @handle.close
   end
end

puts "Path to evm log file"





Readline.completion_append_character = " "
Readline.completion_proc = Proc.new do |str|
  Dir[str+'*'].grep( /^#{Regexp.escape(str)}/ )
end

while line = Readline.readline('> ', true)
  p line
end


#answer = "/Users/jcarter/cfme-logs/log/evm.log"
#answer = gets.chomp

f = MyFile.new("#{answer}")
#f = MyFile.new("/Users/jcarter/cfme-logs/log/evm.log")
puts f.handle.grep (/ ERROR /)

f.finished
