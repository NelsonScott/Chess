class Piece
  def initialize(pos, color, sym, board_object)
    @pos = pos
    @color = color
    @sym = sym
    @board = board_object
  end

  def moves
    #fixme
  end

end

class SteppingPiece < Piece
  attr_accessor :pos
  def initialize(pos, color, sym, board_object, offsets)
    super(pos, color, sym, board_object)
    @offsets = offsets
  end

  def moves
    output = []
    @offsets.each {|offset| output << (offset.zip(@pos).map { |e| e.first + e.last })}
    p output
  end
end

class SlidingPiece < Piece
  def initialize(pos, color, sym, board_object, directions)
    super(pos, color, sym, board_object)
    @directions = directions
  end

  def moves
    output = []
    @directions.each do |dir|
      candidate = [dir[0] + pos[0], dir[1] + pos[1]]
      while valid?(candidate)
        output << candidate
        candidate = [candidate[0] + dir[0], candidate[1] + dir[1]]
      end
    end
  end
end

class Board
  @offsets = [
    [0, -1],
    [1, -1],
    [1, 0],
    [1, 1],
    [0, 1],
    [-1, 1],
    [-1, 0],
    [-1, -1],
  ]

end
