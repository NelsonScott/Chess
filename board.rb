require 'colorize'
require_relative 'chess_piece.rb'
require_relative 'board_helper.rb'

class Board
  attr_accessor :locations
  attr_reader :modifier_hash

  def initialize(size = 8)
    #movements corresponding to each piece
    #also if it's a 'slider' or 'stepper'
    @modifier_hash = BoardHelper.get_modifiers
    @size = size
    ordered_pieces = BoardHelper.get_ordered
    move_type = BoardHelper.get_move_type
    @locations = Array.new(@size) { Array.new (@size) {nil} }

    [:white, :yellow].each do |color|
      (color == :yellow) ? (y_coord = 0) : (y_coord = 7)

      #initialize all the pawns
      y_coord == 0 ? (pawn_y = 1) : (pawn_y = 6)
      size.times do |col|
        @locations[pawn_y][col] = Pawn.new([pawn_y, col], color,
        :p, self, @modifier_hash[:p])
      end

      #initialize the other pieces
      ordered_pieces.each_with_index do |piece_sym, x|
        if (move_type[piece_sym] == :step)
          temp = SteppingPiece.new([y_coord, x], color, piece_sym, self, @modifier_hash[piece_sym])
        else
          temp = SlidingPiece.new([y_coord, x], color, piece_sym, self, @modifier_hash[piece_sym])
        end
        @locations[y_coord][x] = temp
      end
    end
  end


  def try_move(m_start, m_end)
    x1, y1 = m_start
    piece = @locations[x1][y1]

    x2, y2 = m_end
    #commented out incheck? condition for now
    #Refactor
    #make valid_move call just in board
    #make movespace check for intersection all at once, same team or otherwise

    dupped_board = deep_dup
    dupped_board.move(m_start, m_end)
    if piece.valid_move?([x2,y2]) && piece.moves.include?(m_end) && !dupped_board.in_check?(self[m_start].color)

      move(m_start, m_end)
    else
      puts "Invalid move."
    end
  end

  def move(m_start, m_end)
    row_fin, col_fin = m_end
    row_beg, col_beg = m_start
    self[m_start].pos = m_end
    #possibly refactor this to just self[] for each.
    @locations[row_fin][col_fin] = @locations[row_beg][col_beg]
    @locations[row_beg][col_beg] = nil
  end

  def [](pos)
    x, y = pos
    @locations[x][y]
  end

  def in_range(m_arr)
    range = (0...@size)
    return true if (range.include?(m_arr[0]) && range.include?(m_arr[1]))
    false
  end

  def in_check?(color)
    #find position of king
    king_pos = []
    self.locations.each do |row|
      row.each do |piece|
        if !piece.nil? && piece.sym == :kg && piece.color == color
          king_pos = piece.pos
        end
      end
    end

    #check to see if any potential move puts king in check
    self.locations.each do |row|
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

  def checkmate?(color)
    self.locations.each do |row|
      row.each do |piece|
        if !piece.nil? && piece.color == color
          piece.moves.select{|m| piece.valid_move?(m) }.each do |mov|
            dupped = deep_dup
            dupped.move(piece.pos, mov)
            if !dupped.in_check?(color)
              return false
            end
          end
        end
      end
    end

    true
  end

  def deep_dup
    dupped_board = Board.new
    dupped_arr = Array.new(@size) { Array.new (@size) {nil} }
    @locations.each_with_index do |row, idx1|
      row.each_with_index do |piece, idx2|
        if SteppingPiece == piece.class
          dupped_piece = SteppingPiece.new(piece.pos, piece.color,
          piece.sym, dupped_board, @modifier_hash[piece.sym])
        elsif SlidingPiece == piece.class
          dupped_piece = SlidingPiece.new(piece.pos, piece.color,
          piece.sym, dupped_board, @modifier_hash[piece.sym])
        elsif Pawn == piece.class
          dupped_piece = Pawn.new(piece.pos, piece.color,
          piece.sym, dupped_board, @modifier_hash[piece.sym])
        else
          #nil, do nothing
        end

        dupped_arr[idx1][idx2] = dupped_piece
      end
    end

    dupped_board.locations = dupped_arr
    dupped_board
  end

  def inspect
    images = {:r => "♜", :kn => "♞", :b => "♝", :q => "♛", :kg => "♚", :p => "♙"}

    i = 0
    print "  "
    8.times do |iter|
      print " #{iter} "
    end
    puts ""
    @locations.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each do |piece|
        if i % 2 == 0
          back = :red
        else
          back = :black
        end

        if piece.nil?
          print "   ".colorize(:background => back)
        else
          str = images[piece.sym]
          print " #{str} ".colorize(:color => piece.color, :background => back)
        end

        i+=1
      end
      i+=1
      puts ""
    end
  end

end
