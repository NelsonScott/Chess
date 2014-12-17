# encoding: utf-8
require 'colorize'
require_relative 'chess_piece.rb'
require_relative 'modifiers.rb'

class Board
  attr_accessor :locations


  def initialize(size = 8)
    modifer_hash = Modifiers.get_modifiers

    @size = size
    ordered_pieces = Modifiers.get_ordered
    move_type = Modifiers.get_move_type
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
          print " #{str} ".colorize(:color => :white, :background => back)
        end

        i+=1
      end
      i+=1
      puts ""
    end
  end

end
