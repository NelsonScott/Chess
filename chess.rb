require_relative 'board.rb'

class Chess
  def play
    b = Board.new
    puts "\nWelcome to Chess"
    puts "To exit, press 'q'"
    loop do
      # system "clear" #or system "cls"
      b.inspect
      puts "\nPlease enter the coordinates of the piece to move."
      start = get_input
      puts "Please enter the coordinates of where to move it."
      finish = get_input

      b.try_move(start, finish)
    end
  end

  def get_input
    input = gets.chomp
    if input == 'q'
      puts "Goodbye."
      exit
    end

    input.split.map(&:to_i)
  end
end

chess = Chess.new
chess.play
