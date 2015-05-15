class Minefield

	attr_reader :height,
	  :width,
	  :size,
	  :total_mines,
	  :cell_at,
	  :window_width,
	  :window_height

	attr_accessor :flags_left,
	  :cleared_cells,
	  :cells_with_mines

	DIFFICULTY = [:easy, :medium, :difficult, :custom]
	MOVE_TYPES = [:search, :flag, :unflag]	
	include UserInputValidation

	def initialize
		clear_screen
		set_difficulty
		map_board
		@cells_with_mines = [] 
		place_mines
		calculate_risk
		resize_window
		@cleared_cells = []
	end


##################### INITIALIZATION METHODS ######################


	def set_difficulty
		difficulty = gets_from_values(
			DIFFICULTY,
			first_letter_ok: true,
			prompt: "Skill level: 'E'asy, 'M'edium, 'D'ifficult, or 'C'ustom?"
		)
		@height, @width, @total_mines = *case difficulty
		when :easy
			[7, 7, 8]
		when :medium
			[10, 12, 20]
		when :difficult
			[10, 25, 50]
		when :custom
			height = gets_from_range(5, 10,
				prompt: "How tall would you like the board?")
			width = gets_from_range(5, 30,
				prompt: "How wide would you like the board?")
			total_mines = gets_from_range(1, (height * width - 1),
				prompt: "How many mines would you like on the board?")
			[height, width, total_mines]
		else
			puts "How did you get here? Invalid difficulty"
			[nil,nil,nil]
		end

		# Set remaining difficulty-dependent variables
		@size = @width * @height
		@flags_left = @total_mines
		@window_width = (@width * 2) + 20
		@window_height = @height + 16
	end



	# Creates a two-dimensional array to store
	# each cell_at cell in a grid
	def map_board
		@cell_at = []
		@height.times do |row|
			@cell_at[row] = []
			@width.times do |col|
				@cell_at[row][col] = Cell.new
			end
		end
	end



	# Select random mines and mark them on board
	# Store list of active mines in active_mines array
	def place_mines
		(0...@size).to_a.shuffle.slice(0,@total_mines).each do |rand|
			mine_row = rand / @width
			mine_col = rand % @width
			@cell_at[mine_row][mine_col].risk = :mine
			@cells_with_mines << [mine_row, mine_col]
		end
	end



	def calculate_risk
		# Determine risk for clear cells
		@cell_at.each_with_index do |row, this_row|
			row.each_with_index do |col, this_col|
				# Only calculate risk for mineless cells
				if col.risk == :clear
					adj_rows = [this_row - 1, this_row, this_row + 1]
					adj_cols = [this_col - 1, this_col, this_col + 1]
					risk = 0
					adj_rows.each do |row|
						adj_cols.each do |col|
							if (0...@height) === row && (0...@width) === col
								risk += 1 if @cell_at[row][col].risk == :mine
							end
						end
					end
					risk = "." if risk == 0
					@cell_at[this_row][this_col].risk = risk.to_s
				end
			end
		end
	end



	def resize_window
		print "\e[8;#{@window_height};#{@window_width}t"
	end


######################## GENERAL METHODS ##########################


	def clear_screen() print "\033c" end



	# Center a message
	# Centers each line if an array is passed in
	def center_this(msg)
		if msg.class == Array
			msg.each do |line|
				center_this line
			end
		else
			print msg.center(@window_width, " ")
		end
	end



	# Formats messages to the player with cute styling and centered text
	# Accepts both strings and arrays of strings
	def prompt(msg)
		divider = "-⚑-"
		@width.times { divider << "--" }
		divider << "-⚑-"
		center_this [divider, msg, divider]
		puts
	end




	# Render the minefield to the screen
	def render
		clear_screen
		center_this [""," MINESWEE\u2691ER"]

		# Create the upper and lower vertical edges of board
		board_vertical_edge = "  +"
		@width.times { board_vertical_edge << "--" }
		board_vertical_edge << "-+"

		# Display column headers vertically to save space
		# Places tens place directly above the ones place, if necessary
		tens = "   "
		ones = "   "
		@width.times do |x|
			if x >= 10
				tens << x.to_s[0] + " "
				ones << x.to_s[1] + " "
			else
				tens << "  "
				ones << x.to_s + " "
			end
		end
		center_this tens if @width >= 11
		center_this ones
		center_this board_vertical_edge # Display top edge of board

		# Loop through and display each row
		@cell_at.each_with_index do |row, row_title|
			# Add the row title, as a letter, to the row contents
			row_contents = row_title.to_s.tr("0-9", "a-z").upcase + " | "
			# Loop through each cell in row and it to row contents
			row.each do |col|
				case col.state
				when :hidden
					row_contents << "\u2591 "
				when :flagged
					row_contents << "\u2691 "
				when :visible
					row_contents << col.risk unless col.risk == :mine
					row_contents << "\u2699" if col.risk == :mine
					row_contents << " "
				end
			end
			row_contents << "|"
			center_this row_contents # Display row
		end
		center_this board_vertical_edge # Display bottom edge of board
		center_this "  FLAGS LEFT: #{@flags_left}" # Display remaining flags
		puts
		puts
	end



	# Search a cell for mines
	# If the cell has no neighboring mines,
	# inspect the surrounding cells
	# until a cell touching a mine is reached
	def clear_cell(row, col)
		@cell_at[row][col].state = :visible
		@cleared_cells << [row, col]

		if  @cell_at[row][col].risk == "."
			# Find neighboring cell coordinates
			neighbors = []
			adj_rows = [row - 1, row, row + 1]
			adj_cols = [col - 1, col, col + 1]		
			adj_rows.each do |neighbor_row|
				adj_cols.each do |neighbor_col|
					# Exclude coordinates beyond the edges of cell_at
					if (0...@height) === neighbor_row && (0...@width) === neighbor_col
						# Exclude cells which have already been cleared
						unless @cleared_cells.include?([neighbor_row, neighbor_col])
							neighbors << [neighbor_row, neighbor_col]
						end
					end
				end
			end
			# Repeat these steps for each neighboring cell
			neighbors.each { |neighbor| clear_cell(neighbor[0],neighbor[1]) }
		end
	end
end



class Cell
	attr_accessor :state, :risk
	def initialize
		@state = :hidden
		@risk = :clear
	end
end