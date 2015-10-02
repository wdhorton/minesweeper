class Game

  attr_reader :board, :players

  def initialize(board, players)
    @board = board
    @players = players
 end

 def reveal(pos)
   if board[pos].bomb
      game_over
   else
     board.reveal(pos)
   end
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
  end

  def reveal(pos)
    queue = [pos]

    until queue.empty?
      space = queue.shift
      self[space].reveal = true
      if self[space].value.zero?
        queue += adjacent_spaces(space).reject { |sp| self[sp].reveal }
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
      "*"
    end
  end
end
