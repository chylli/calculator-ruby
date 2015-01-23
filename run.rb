require 'parser'

parser = Parser.new

puts parser.parse('2 + ( ( 4 + 6 ) * (9 - 2) - 5 - 1) + 1')
puts parser.parse('2 + ( ( 4 + 6 ) * sqrt(5) + 3) / 2  + 1')
