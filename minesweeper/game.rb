# coding: utf-8
require_relative 'board.rb'
require 'byebug'

class Game

  attr_reader :board, :players

  def initialize(size = 9)
    @board = Board.new(size)
  end

  def play
    until board.game_over?
      system("clear")
      board.display
      action, pos = get_player_input
      tile = board[pos]
      if action == "f"
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
    board.tiles.each { |tile| tile.reveal = true }
    board.display
  end

end
