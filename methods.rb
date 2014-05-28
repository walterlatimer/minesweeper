module UserInputValidation

	# Ask user for a number within a range
	# Return error and prompt again if necessary
	# Accepts a block to display a custom prompt
	def gets_from_range(min, max, options = {})
		error = nil
		loop do
			puts error if error
			puts options[:prompt] if options[:prompt]
			input = gets.chomp.to_i
			return input if (min..max) === input
			error = "Must be between #{min} and #{max}. Try again."
		end
	end

	# Ask user for a string from a set of values
	# Return error and prompt again if necessary
	# Accepts a block to display a custom prompt
	# Returns input as symbol
	def gets_from_values(array_of_values, options = {})
		if array_of_values.class == Array
			array_of_values.map! { |x| x.to_s }
			error = nil
			loop do
				puts error if error
				puts options[:prompt] if options[:prompt]
				input = gets.chomp.to_s.downcase
				return input.to_sym if array_of_values.include? input
				# first_letter_ok option in case multiple options
				# begin with the same letter
				if options[:first_letter_ok] && input.size == 1   # Can be refactored
					array_of_values.each do |value|
						return value.to_sym if input[0] == value[0]
					end
				end
				error = "Didn't catch that.  Try again."
			end
		end
	end









end