class Piece
  def initialize(pos, color, sym, board_object)
    @pos = pos
    @color = color
    @sym = sym
    @board_object = board_object
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
  attr_reader :color
  def initialize(pos, color, sym, board_object, directions)
    super(pos, color, sym, board_object)
    @directions = directions
  end

  def moves
    output = []
    @directions.each do |dir|
      candidate = [dir[0] + @pos[0], dir[1] + @pos[1]]
      while valid?(candidate)
        output << candidate
        break if intersects_other?(candidate)
        candidate = [candidate[0] + dir[0], candidate[1] + dir[1]]
      end
    end

    output
  end

  def valid?(move)
    @board_object.in_range(move) && !intersects_same?(move) && !@board_object.in_check?(@color)
  end

  def intersects_same?(move)
    #checks if intersects our own piece
    !@board_object[move].nil? && (@board_object[move].color == @color)
  end

  def intersects_other?(move)
    !@board_object[move].nil? && (@board_object[move].color != @color)
  end

  def inspect
    puts "I am #{@sym} at #{@pos}"
  end

end

class Board
  attr_accessor :locations
  # @offsets = [
  #   [0, -1],
  #   [1, -1],
  #   [1, 0],
  #   [1, 1],
  #   [0, 1],
  #   [-1, 1],
  #   [-1, 0],
  #   [-1, -1],
  # ]
  def initialize(size = 8)
    @size = size
    @locations = Array.new(@size) { Array.new (@size) {nil} }
  end

  def [](pos)
    x, y = pos
    @locations[x][y]
  end

  def in_range(move)
    range = (0...@size)
    return true if (range.include?(move[0]) && range.include?(move[1]))

    false
  end

  def in_check?(color)
    false
  end

end

diagonals = [
  [1,1],
  [-1, -1],
  [1, -1],
  [-1, 1]
]
orthagonals = [
  [0,1],
  [0, -1],
  [1, 0],
  [-1, 0]
]

b = Board.new
rook1 = SlidingPiece.new([0,5], :white, :rookie, b, orthagonals)
b.locations[0][5] = rook1
p b.locations[0][5]

rook2 = SlidingPiece.new([0,1], :black, :blackie, b, orthagonals)
b.locations[0][1] = rook2
p b.locations[0][1]

rook2.moves.each do |arr|
  print arr
  puts ""
end
