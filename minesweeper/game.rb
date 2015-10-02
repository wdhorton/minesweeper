# coding: utf-8
require_relative 'board.rb'
require_relative 'keystrokes.rb'
require 'byebug'
require 'colorize'

class Game

  def self.load(file_name)
    YAML.load(File.read(file_name)).play
  end

  attr_reader :board, :players

  def initialize(size = 9)
    @board = Board.new(size)
  end

  def play
    until board.game_over?
      system("clear")
      board.display
      action, pos = get_player_input
      tile = board[pos] if pos
      if action == "s"
        save
        exit
      elsif action == "f"
        tile.toggle_flag
      else
        tile.reveal_tile
      end
    end
    game_over
  end

  def get_player_input
    parse_input(gets.chomp)
  end

  def parse_input(str)
    [str[0], [str[2].to_i,str[4].to_i]]
  end

  def game_over
    system("clear")
    puts (board.won? ? "You Won!" : "BOOM")
    board.display
  end

  def save
    puts "Enter File Name:"
    file_name = gets.chomp
    string = to_yaml
    f = File.new(file_name, "w")
    f.write(string)
    f.close
  end

  # modified from https://gist.github.com/acook/4190379
  # original case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  def interpret_keystroke(c)
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
  Game.new.play
end
