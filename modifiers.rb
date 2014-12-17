class Modifiers
  def self.get_modifiers
    diagonals = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    orthagonals = [[0,1],[0, -1],[1, 0],[-1, 0]]

    king_offsets = diagonals + orthagonals

    knight_offsets = [[1, -2], [2, -1], [2, 1], [1, 2],
                    [-1, 2], [-2, 1], [-2, -1], [-1, -2]]
    queen_directions = diagonals + orthagonals
    bishop_directions = diagonals
    rook_directions = orthagonals

    @modifiers = Hash.new
    @modifiers[:kg] = king_offsets
    @modifiers[:q] = queen_directions
    @modifiers[:b] = bishop_directions
    @modifiers[:r] = rook_directions
    @modifiers[:kn] = knight_offsets
    #still need pawn, remember

    @modifiers
  end

  def self.get_ordered
    [:r, :kn, :b, :q, :kg, :b, :kn, :r]
  end

  def self.get_move_type
    {:r => :slide, :kn => :step, :b => :slide,
      :q => :slide, :kg => :step}
  end
end
