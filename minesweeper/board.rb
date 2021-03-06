require_relative 'tile.rb'

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
  def initialize(size)
    @grid = Array.new(size) { Array.new(size) { Tile.new(self) } }
    add_bombs
  end

  def[](pos)
    x,y = pos
    grid[x][y]
  end

  def add_bombs(number = 15)
    bombs = 0
    tiles.shuffle.each do |tile|
      return nil if bombs == number
      tile.bomb = true
      bombs += 1
    end
  end

  def count_bombs(pos)
    adjacent_spaces(pos).count { |sp| self[sp].bomb }
  end

  def adjacent_spaces(position)
     x,y = position
     adjs = ADJACENTS.map { |space| [x + space.first, y + space.last] }
     adjs.select { |space| on_board?(space) }
  end

  def on_board?(loc)
    loc.all? { |n| n.between?(0, grid.length - 1) }
  end

  def display
    strings = tiles.map { |tile| tile.to_s }
    num_rows = strings.each_slice(grid.length).map do |line|
       "║ " + line.join(" │ ") + " ║\n"
    end
    top_row =    "╔" + "═══╤" * (grid.length - 1) + "═══╗\n"
    bottom_row = "╚" + "═══╧" * (grid.length - 1) + "═══╝\n"
    middle_row = "╟" + "───┼" * (grid.length - 1) + "───╢\n"
    box = top_row + (num_rows.join(middle_row)) + bottom_row
    puts box
  end

  def reveal_surrounding_spaces(pos)
    adjacent_tiles = adjacent_spaces(pos).map { |po| self[po] }
    adjacent_tiles = adjacent_tiles.reject { |tile| tile.reveal || tile.flag  }
    adjacent_tiles.each(&:reveal_tile)

    nil
  end

  def tiles
    grid.flatten
  end

  def won?
    (tiles.all? { |tile| tile.bomb || tile.reveal }) ||
    (tiles.select(&:bomb) == tiles.select(&:flag))

  end

  def lost?
    tiles.any? { |tile| tile.bomb && tile.reveal }
  end

  def game_over?
    won? || lost?
  end
end
