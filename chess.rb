require_relative 'board.rb'

class Chess
  def play
    b = Board.new
    puts "\nWelcome to Chess"
    puts "To exit, press 'q'"

    turns = [:white, :yellow]
    i = 0
    loop do
      system "clear" #or system "cls"
      turn = turns[i % 2]
      if turn == :white
        puts "White player's turn"
        if b.in_check?(turn)
          puts "You are in check."
          if b.checkmate?(turn)
            puts "You have been checkmated."
            b.inspect
            exit
          end
        end
      else
        puts "Yellow player's turn"
        if b.in_check?(turn)
          puts "You are in check."
          if b.checkmate?(turn)
            puts "You have been checkmated."
            b.inspect
            exit
          end
        end
      end

      b.inspect
      puts "\nPlease enter the coordinates of the piece to move."
      start = get_input
      puts "Please enter the coordinates of where to move it."
      finish = get_input

      b.try_move(start, finish)
      i+=1
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
