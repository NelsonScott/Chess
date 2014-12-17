class Piece
  attr_reader :sym, :color
  attr_accessor :pos
  def initialize(pos, color, sym, board_object)
    @pos = pos
    @color = color
    @sym = sym
    @board_object = board_object
  end

  def moves
  end

  def valid?(move)
    @board_object.in_range(move) && !intersects_same?(move)
  end

  def intersects_same?(move)
    !@board_object[move].nil? && (@board_object[move].color == @color)
  end

  def intersects_other?(move)
    !@board_object[move].nil? && (@board_object[move].color != @color)
  end

  def inspect
    puts "Sym: #{@sym} Pos: #{@pos}"
  end

end

class SteppingPiece < Piece
  def initialize(pos, color, sym, board_object, offsets)
    super(pos, color, sym, board_object)
    @offsets = offsets
  end

  def moves
    output = []
    @offsets.each {|offset| output << (offset.zip(@pos).map { |e| e.first + e.last })}
    output.select{|move| valid?(move)}
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
      candidate = [dir[0] + @pos[0], dir[1] + @pos[1]]
      while valid?(candidate)
        output << candidate
        break if intersects_other?(candidate)
        candidate = [candidate[0] + dir[0], candidate[1] + dir[1]]
      end
    end

    output
  end
end
