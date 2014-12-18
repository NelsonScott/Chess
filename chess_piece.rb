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

  def valid_move?(move)
    @board_object.in_range(move) && !intersects_same?(move)
  end

  def intersects_same?(move)

    if @board_object[move].nil?
      return false
    else
      return (@board_object[move].color == @color)
    end
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
    # output.select{|move| valid_move?(move)}
    ##ALREADY CHECK IF VALID!##
    output
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
      while valid_move?(candidate)
        output << candidate
        break if intersects_other?(candidate)
        candidate = [candidate[0] + dir[0], candidate[1] + dir[1]]
      end
    end

    output
  end
end

class Pawn < SteppingPiece
  def initialize(pos, color, sym, board_object, offsets)
    super(pos, color, sym, board_object, offsets)
    # @offsets = offsets
  end

  #needs to override such that it can move diagonal front if piece there
  #and CANNOT move forward up if there is any piece there
  #just flip the y values if white/yellow
  def moves
    output = []
    if @color == :yellow
      @offsets = [[1, 0],[2, 0],[1, -1], [1, 1]]
    else
      @Offsets = [[-1, 0],[-2, 0],[-1, -1], [-1, 1]]
    end

    #Change the y direction of the move offsets to account for the black player being on the
    #opposite side of the board.

    @offsets.each {|offset| output << (offset.zip(@pos).map { |e| e.first + e.last })}

    #Only allow diagonals if capture possible
    output[-2..-1].each do |my_position|
      if !intersects_other?(my_position)
        idx = output.index(my_position)
        output[idx] = nil
      end
    end

    #Only allow forward move if destination is empty
    output[0..1].each do |my_position|
      if intersects_other?(my_position)
        idx = output.index(my_position)
        output[idx] = nil
      end
    end

    output.reject(&:nil?)
  end

end
