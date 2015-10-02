# modified from https://gist.github.com/acook/4190379

require 'io/console'

class UserInput
# Reads keypresses from the user including 2 and 3 escape character sequences.
def self.read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end

# oringal case statement from:
# http://www.alecjacobson.com/weblog/?p=75
def self. show_single_key
  c = read_char

  case c
  when " "
    puts "SPACE"
  when "\e[A"
    puts "UP ARROW"
  when "\e[B"
    puts "DOWN ARROW"
  when "\e[C"
    puts "RIGHT ARROW"
  when "\e[D"
    puts "LEFT ARROW"
  when /^.$/
    puts "SINGLE CHAR HIT: #{c.inspect}"
  else
    nil
  end
end
end

if __FILE__ == $PROGRAM_NAME
  UserInput::show_single_key while(true)
end
