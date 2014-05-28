def resize_window() print "\e[8;25;31t" end

def clear_screen() print "\033c" end

def print_divider() puts "-⚑---------------------⚑--".center(31, " ") end

# Center a message
# Centers each line if an array is passed in
def center_this(msg)
	if msg.class == Array
		msg.each do |line|
			center_this line
		end
	else
		print msg.center(31, " ")
	end
end

# Clears the screen and animates the contents of a full-screen message
# Screen contents MUST be passed in as an array
def cut_to(screen)
	clear_screen
	screen.each do |line|
		center_this line
		sleep(0.1)
	end
	sleep(2)
end

# Formats messages to the player with cute styling and centered text
# Prompt contents MUST be passed in as an array
def prompt(message)
	print_divider
	message.each do |line|
		center_this line
	end
	print_divider
	puts
end

# Initialize the minefield
minefield = {
	a: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], b: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], c: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], d: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], e: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], f: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], g: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	], h: [
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}, 
		{type: :clear, status: :hidden},
		{type: :clear, status: :hidden}
	]
}

total_flags = 8
flagged_blocks = []
loser = nil

# Select random mines and mark them as rigged
# Store list of active mines in active_mines array
active_mines = [] 
(0..79).to_a.shuffle.slice(0,total_flags).each do |position|
	rigged_x = (position / 10).to_s.tr("0-9", "a-h").to_sym
	rigged_y = position % 10
	minefield[rigged_x][rigged_y][:type] = :rigged
	active_mines << {row: rigged_x, col: rigged_y}
end





opening_credits = [
	"",
	"#############################",
	"#############################",
	"#############   #############",
	"############# M #############",
	"############# I #############",
	"############# N #############",
	"############# E #############",
	"#############   #############",
	"############# S #############",
	"############# W #############",
	"############# E #############",
	"############# E #############",
	"############# P #############",
	"############# E #############",
	"############# R #############",
	"#############   #############",
	"#############################",
	"#############################",
	"#############   #############",
	"############  ⚑  ############",
	"#############   #############",
	"#############################",
	"#############################"
]

game_over = [
	"",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"###                       ###",
	"###  YOU TRIPPED A MINE!  ###",
	"###                       ###",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"########             ########",
	"########  GAME OVER  ########",
	"########             ########",
	"#############################",
	"#############################",
	"#############################",
	"#############################",
	"#############################"
]

new_turn_msg = [
	"Would you like to",
	"'F'lag a block for mines,",
	"'U'nflag a block, or",
	"'R'eveal a hidden block?"
]

input_coords_msg = [
	"Enter coordinates",
	"letter, then number",
	"(such as E7)"
]

minefield_header = [
	"",
	"-⚑------MINESWEEPER-----⚑-",
	"",
	"",
	"   0 1 2 3 4 5 6 7 8 9",
	"  +---------------------+"
]



resize_window
cut_to opening_credits


until loser

	clear_screen


	############################
	# Begin minefield display ##
	############################


	center_this minefield_header
	minefield.each do |row, col_info|
		row_title = row.to_s.upcase
		row_output = "#{row_title} | "
		col_info.each_with_index do |this_block, col|
			case this_block[:status]
			when :hidden
				row_output << "\u2591 " # Display ░ for hidden blocks

			when :visible
				# Calculate previous and next columns and rows
				this_row = row.to_s.tr("a-h", "0-9").to_i # Numerical representation of row
				this_col = col.to_i
				prev_row = (this_row - 1).to_s.tr("0-9", "a-h").to_sym
				next_row = (this_row + 1).to_s.tr("0-9", "a-h").to_sym
				prev_col = this_col - 1
				next_col = this_col + 1


				# Calculate risk by inspecting surrounding blocks for mines
				# Skip certain checks for edge blocks
				risk = 0
				unless this_row <= 0
					risk += 1 if this_col > 0 && minefield[prev_row][prev_col][:type] == :rigged
					risk += 1 if minefield[prev_row][col][:type] == :rigged
					risk += 1 if this_col < 9 && minefield[prev_row][next_col][:type] == :rigged
				end

				unless this_row >= 7
					risk += 1 if this_col > 0 && minefield[next_row][prev_col][:type] == :rigged
					risk += 1 if minefield[next_row][col][:type] == :rigged
					risk += 1 if this_col < 9 && minefield[next_row][next_col][:type] == :rigged
				end

				unless this_col <= 0
					risk += 1 if minefield[row][prev_col][:type] == :rigged
				end

				unless this_col >= 9
					risk += 1 if minefield[row][next_col][:type] == :rigged
				end

				risk = " " if risk == 0 # Empty if no risk

				# Add risk score to row_output
				row_output << risk.to_s + " "

			when :flagged
				row_output << "\u2691" # ⚑
			end
		end 

		row_output << "|" # end the minefield
		center_this row_output

	end # End printing of each row

	remaining_flags = total_flags - flagged_blocks.size

	center_this "  +---------------------+" # Bottom edge of minefield
	center_this "   FLAGS LEFT: #{remaining_flags}"
	puts "\n\n"

	############################
	# End of minefield display #
	############################

	puts active_mines


	# Collect move type
	# Return error if invalid move type
	move_type_error = nil
	move_type_input = nil

	until move_type_input
		move_type_error ? prompt(move_type_error) : prompt(new_turn_msg)
		move_type_input = gets.chomp.downcase
		case move_type_input
		when "f", "flag"
			move_type_input = :flag
			break
		when "u", "unflag"
			move_type_input = :unflag
			break
		when "r", "reveal"
			move_type_input = :reveal
			break
		else
			move_type_error = ["Huh? Didn't catch that.",
			"Try again... 'F'lag,",
			"'U'nflag, or 'R'eveal?"]
			move_type_input = nil
		end

	end


	# Get coordinates of input block
	# Return errors and ask again if necessary
	# Change states of affected blocks
	input_error = nil
	loop do
		input_error ? prompt(input_error) : prompt(input_coords_msg)
		input_coords = gets.chomp.downcase
		input_x = input_coords[0].to_sym
		input_y = input_coords[1].to_i

		if minefield[input_x][input_y][:type] == :rigged
			loser = true
			break
		else
			if minefield[input_x][input_y][:status] == :visible
				error =  "ALREADY CLEARED"
			elsif minefield[input_x][input_y][:status] == :flagged
				puts "YOU'VE FLAGGED THIS ALREADY"
			else
				puts "CLEAR"
				minefield[input_x][input_y][:status] = :visible
				break
			end
		end


	end








end

print "\a\a\a\a\a"
if loser
	cut_to game_over 
else
end






# case block_status
# when :is_flagged
# when :is_hidden
# else
# 	# Calculate contents
# end