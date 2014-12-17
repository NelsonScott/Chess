# encoding: utf-8
require 'colorize'
require_relative 'chess_piece.rb'
require_relative 'board_helper.rb'

class Board
  attr_accessor :locations


  def initialize(size = 8)
    #movements corresponding to each piece
    #also if it's a 'slider' or 'stepper'
    modifer_hash = BoardHelper.get_modifiers
    @size = size
    ordered_pieces = BoardHelper.get_ordered
    move_type = BoardHelper.get_move_type
    @locations = Array.new(@size) { Array.new (@size) {nil} }

    [:white, :yellow].each do |color|
      (color == :yellow) ? (y_coord = 0) : (y_coord = 7)

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


  def try_move(m_start, m_end)
    p "Trying move"
    x1, y1 = m_start
    p "x1: #{x1} y1: #{y1}"
    piece = @locations[x1][y1]
    p "Original piece class: #{piece.sym}"

    x2, y2 = m_end
    p "x2: #{x2} y2: #{y2}"
    #commented out incheck condition for now
    if piece.valid?([x2,y2]) #&& !in_check?(m_start, m_end)
      move(m_start, m_end)
    else
      puts "Invalid move."
    end
  end

  def move(m_start, m_end)
    p "m_start: #{m_start}"
    p "m_end: #{m_end}"
    p "Value at start location: #{self[m_start].class}"
    p "Value of that .pos: #{self[m_start].pos}"
    p "m_end: #{m_end}"
    row_fin, col_fin = m_end
    row_beg, col_beg = m_start
    self[m_start].pos = m_end
    p "Set end location to start piece's position"
    p "Value of start piece's pos: #{self[m_start].pos}"
    @locations[row_fin][col_fin] = @locations[row_beg][col_beg]
    @locations[row_beg][col_beg] = nil
    # self[m_end] = self[m_start]
    # self[m_start] = nil

    p "Value at the previous start: #{@locations[row_beg][col_beg].class}"
    p "Value at the end: #{@locations[row_fin][col_fin].sym}"

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
    #have not finished, need to revist
    color = @locations[m_start].color
    dupped_board = deep_dup
    dupped_board.move(m_start, m_end)

    king_pos = []
    dupped_board.locations.each do |row|
      row.each do |piece|
        if piece.sym == :kg && piece.color == color
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
    #rethink this
    # deep_dupped = Array.new(@size) { Array.new (@size) {nil} }
    # self.locations.each_with_index do |row, y|
    #   row.each do |piece, x|
    #tTEST before IMPLEMENTING THIS
    #   if piece.class ==
    #   temp = SteppingPiece.new([y_coord, x], color, piece, self, modifer_hash[piece])
    # else
    #   temp = SlidingPiece.new([y_coord, x], color, piece, self, modifer_hash[piece])
    #
    #   dupped =
    #   deep_dupped.locations[y][x]
    # end
    # end
  end

  def inspect
    images = {:r => "♜", :kn => "♞", :b => "♝", :q => "♛", :kg => "♚"}

    i = 0
    @locations.each do |row|
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
