class Tile
  attr_accessor :bomb, :reveal, :flag, :value
  attr_reader :board

  def initialize(board)
    @board = board
    @bomb = false
    @reveal = false
    @flag = false
  end

  def value
    board.count_bombs(position)
  end

  def position
    board.grid.each.with_index do |row, idx|
      row.each.with_index do |tile, idy|
        return [idx, idy] if tile == self
      end
    end

    nil
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

  def toggle_flag
    flag = !flag
  end

  def reveal_tile
    if flag
       puts "You must unflag this space first"
    else
      self.reveal = true
      board.reveal_surrounding_spaces(position) if value.zero?
    end
  end
end
