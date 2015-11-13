require 'erb'
source = ARGV[0]
destination = ARGV[1]
File.write(destination, ERB.new(File.read(source)).result(binding))
