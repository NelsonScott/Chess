require 'yaml'

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
    #fixme
  end

  def valid?(move)
    @board_object.in_range(move) && !intersects_same?(move)
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

class Board
  attr_accessor :locations


  def initialize(size = 8)
    modifer_hash = Modifiers.get_modifiers

    @size = size
    ordered_pieces = [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook]
    move_type = {:rook => :slide, :knight => :step, :bishop => :slide,
    :queen => :slide, :king => :step}

    @locations = Array.new(@size) { Array.new (@size) {nil} }

    [:white, :black].each do |color|
      (color == :black) ? (y_coord = 0) : (y_coord = 7)

      ordered_pieces.each_with_index do |piece, x|
        if (move_type[piece] == :step)
          temp = SteppingPiece.new([y_coord, x], color, piece, self, modifer_hash[piece])
        else
          temp = SlidingPiece.new([y_coord, x], color, piece, self, modifer_hash[piece])
        end
        @locations[y_coord][x] = temp

      end
    end

  end

  def do_move(m_start, m_end)
    #take input()
    x, y = m_start
    piece = @locations[x][y]
    if piece.valid?([x,y]) && !in_check?(m_start, m_end)
      move(m_start, m_end)
    end
  end

  def move(m_start, m_end)
    @locations[m_start].pos = m_end
    @locations[m_start], @locations[m_end] = nil, @locations[m_start]
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

  def in_check?(m_start, m_end)
    color = @locations[m_start].color
    dupped_board = deep_dup
    dupped_board.move(m_start, m_end)

    king_pos = []
    dupped_board.locations.each do |row|
      row.each do |piece|
        if piece.sym == :king && piece.color == color
          king_pos = piece.pos
        end
      end
    end


    dupped_board.locations.each do |row|
      row.each do |piece|
        if !piece.nil? && piece.color != color
          potential = piece.moves
          if potential.include?(king_pos)
            return true
          end
        end
      end
    end

    false
  end

  def deep_dup
    deep_dupped = Array.new(@size) { Array.new (@size) {nil} }
    self.locations.each_with_index do |row, y|
      row.each do |piece, x|
        #tTEST before IMPLEMENTING THIS
      #   if piece.class ==
      #   temp = SteppingPiece.new([y_coord, x], color, piece, self, modifer_hash[piece])
      # else
      #   temp = SlidingPiece.new([y_coord, x], color, piece, self, modifer_hash[piece])
      #
      #   dupped =
      #   deep_dupped.locations[y][x]
      # end
    end
      # temp = self.to_yaml
      # YAML::load(temp)
  end

  def inspect
    @locations.each do |row|
      row.each do |piece|
          if piece.nil?
            print " "
          else
            str = piece.sym.to_s
            print str[0] + " "
          end
        end
      puts ""
    end
  end

end

class Modifiers
  def self.get_modifiers
    diagonals = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    orthagonals = [[0,1],[0, -1],[1, 0],[-1, 0]]

    king_offsets = diagonals + orthagonals

    knight_offsets = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]]
    queen_directions = diagonals + orthagonals
    bishop_directions = diagonals
    rook_directions = orthagonals

    @modifiers = Hash.new
    @modifiers[:king] = king_offsets
    @modifiers[:queen] = queen_directions
    @modifiers[:bishop] = bishop_directions
    @modifiers[:rook] = rook_directions
    @modifiers[:knight] = knight_offsets
    #still need pawn, remember
    #fixme

    @modifiers
  end
end


# b = Board.new
# rook1 = SlidingPiece.new([0,5], :black, :rookie, b, orthagonals)
# b.locations[0][5] = rook1
# p b.locations[0][5]
#
# rook2 = SlidingPiece.new([0,1], :black, :blackie, b, orthagonals)
# b.locations[0][1] = rook2
# p b.locations[0][1]

b = Board.new
b.inspect
puts "orig: #{b.locations}"
copy = b.deep_dup.locations
puts "copy #{copy.locations}"
 b.locations = nil
 puts "cop2 #{copy.locations}"


# rook1 = SteppingPiece.new([0,5], :black, :king, b, @modifiers[:king])
# b.locations[0][5] = rook1
# p b.locations[0][5]
#
# rook2 = SteppingPiece.new([0,1], :black, :blackie, b, orthagonals)
# b.locations[0][1] = rook2
# p b.locations[0][1]
