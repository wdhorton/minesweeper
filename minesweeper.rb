# coding: utf-8
class Game

  attr_reader :board, :players

  def initialize(board, players)
    @board = board
    @players = players
  end

  def play
    until game_over?
      system("clear")
      board.display
      action, pos = get_player_input
      if action == "f"
        toggle_flag(pos)
      else
        reveal(pos)
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

  def reveal(pos)
    if board[pos].flag
       puts "You must unflag this space first"
    else
      board.reveal(pos)
    end
  end

  def toggle_flag(pos)
    flg = board[pos].flag
    board[pos].flag = !flg
  end

  def won?
    (board.grid.flatten.all? { |tile| tile.bomb || tile.reveal }) ||
    (board.grid.flatten.select(&:bomb) == board.grid.flatten.select(&:flag))

  end

  def lost?
    board.grid.flatten.any? { |tile| tile.bomb && tile.reveal }
  end

  def game_over?
    won? || lost?
  end

  def game_over
    system("clear")
    puts (won? ? "You Won!" : "BOOM")
    board.grid.flatten.each { |tile| tile.reveal = true }
    board.display
  end

end

class Board

  ADJACENTS = [
    [-1, -1],
    [0, -1],
    [1, 0],
    [1, 1],
    [0, 1],
    [-1, 0],
    [-1, 1],
    [1, -1]
  ]

  attr_reader :grid
  def initialize(size = 9)
    @grid = Array.new(size) { Array.new(size) { Tile.new } }
    add_bombs
    set_tile_values
  end

  def[](pos)
    x,y = pos
    grid[x][y]
  end

  def add_bombs(number = 15)
    bombs = 0
    @grid.flatten.shuffle.each do |tile|
      return nil if bombs == number
      tile.bomb = true
      bombs += 1
    end
  end

  def set_tile_values
    grid.each.with_index do |row, idx|
      row.each.with_index do |tile, idy|
        tile.value = count_bombs([idx, idy])
      end
    end

    nil
  end

  def count_bombs(pos)
    adjacent_spaces(pos).count { |sp| self[sp].bomb }
  end

  def adjacent_spaces(position)
     x,y = position
     adjacent_spaces = ADJACENTS.map { |space| [x + space.first, y + space.last] }
     adjacent_spaces.select { |space| on_board?(space) }
  end

  def on_board?(loc)
    loc.all? { |n| n.between?(0, grid.length - 1) }
  end

  def display
    grid.each do |row|
      sub_grid = ""
      row.each do |tile|
        sub_grid += tile.to_s + " "
      end
      puts sub_grid + "\n"
    end

    nil
  end

  def reveal(pos)
    queue = [pos]

    until queue.empty?
      space = queue.shift
      self[space].reveal = true
      if self[space].value.zero?
        queue += adjacent_spaces(space).reject { |sp| self[sp].reveal || self[sp].flag  }
      end
    end

    nil
  end

end

class Tile
  attr_accessor :bomb, :reveal, :flag, :value

  def initialize
    @bomb = false
    @reveal = false
    @flag = false
    @value = 0
  end

  def to_s
    if reveal
      if bomb
        "!"
      else
        value.zero? ? "_" : value.to_s
      end

    elsif flag
      "F"

    else
      "⚀"
    end
  end
end
