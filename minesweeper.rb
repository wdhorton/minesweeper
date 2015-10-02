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


end

class Tile
  attr_accessor :bomb, :reveal, :flag, :value

  def initialize
    @bomb = false
    @reveal = false
    @flag = false
    @value = 0
  end



end
