class Board

  def initialize(size = 9)
    @grid = Array.new(size) { Array.new(size) { Tile.new } }
  end

  def add_bombs(number = 15)
    bombs = 0
    @grid.flatten.shuffle.each do |tile|
      return nil if bombs == number
      tile.bomb = true
      bombs += 1
    end
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
