require_relative "methods.rb"
require_relative "minefield.rb"

class Minesweeper

	attr_reader :board

	include UserInputValidation

	def initialize
		@board = Minefield.new
	end

end

game = Minesweeper.new

cell_at = game.board.cell_at




loser = false
flagged_cells = []

until loser

	############# GET INPUT TYPE ###########
	input_type = nil
	loop do
		game.board.render
		game.board.prompt "Search, Flag, or Unflag?"
		input_type = gets.chomp.downcase
		case input_type
		when "s", "search", "f", "flag",  "u", "unflag"
			break
		else
			game.board.prompt ["Huh?  Didn't catch that", "'S'earch, 'F'lag, or 'U'nflag?"]
		end
	end


	############ GET COORDINATES ###########
	loop do
		game.board.render
		game.board.prompt ["Coordinates?","or 'U'ndo selection"]
		user_coords = gets.chomp.downcase


		case user_coords
		when "u", "undo"
			input_type = nil
			break
		else
			user_row = user_coords[0].downcase.tr("a-z", "0-9").to_i
			user_col = user_coords[1..-1].to_i
			selection = cell_at[user_row][user_col]

			case input_type
			# When input is FLAG
			when "flag", "f"
				case selection.state
				when :flagged, :visible
					puts "PLEASE SELECT A HIDDEN CELL"
				when :hidden
					# unless @flags_left <= 0
						selection.state = :flagged
						flagged_cells << [user_row, user_col]
						# @flags_left -= 1
						break
					# else
					# 	puts "out of flags"
					# end
				end
			when "unflag", "u"
			# When input is UNFLAG
				case selection.state
				when :flagged
					selection.state = :hidden
					flagged_cells.delete([user_row,user_col])
					# @flags_left += 1
					break
				when :hidden, :visible
					puts "NOTHING TO UNFLAG HERE"
				end
			when "search", "s"
			# When input is REVEAL
				case selection.state
				when :visible, :flagged
					puts "PLEASE SELECT A HIDDEN CELL"
				when :hidden
					if selection.risk == :mine
						@cells_with_mines.each do |finale|
							cell_at[finale[0]][finale[1]].state = :visible
						end
						loser = true
						break
					else
						puts "CLEAR"
						game.board.clear_cell(user_row,user_col)
						break
					end
				end
			end
		end
	end
	# break if flagged_cells.uniq.sort == @cells_with_mines.uniq.sort
end
game.board.render
puts "YOU WIN"