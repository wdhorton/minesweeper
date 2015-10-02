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
        "!".red
      else
        value.zero? ? "_".light_black : value.to_s.blue
      end
    elsif flag
      "⚑".green
    else
      if board.game_over? && bomb
        "!".light_red
      end
      " "
    end
  end

  def toggle_flag
    self.flag = !flag
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
