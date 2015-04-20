require 'terminfo'
require 'JSON'
require 'pry'
require 'io/console'

class CalculateWidth
	def execute
		"%"+(TermInfo.screen_size[1]/2).to_s+"s"
	end
end

class CalculateRight
	def execute
		"%"+(TermInfo.screen_size[1]).to_s+"s"
	end
end

class SteveTerminal
	def start
		system("clear")
		index = 1
		puts "Fancy an autopilot presentation?"
		if gets.chomp == "yes"
			ShowAutopilot.new.presentation
		else
			ShowSlide.new.presentation(1)
		end
	end
end

class ShowAutopilot
	def initialize
		@slides = JSON.parse(IO.read("jobsslides.txt")).to_a.flatten.delete_if {|item| item[0, 3] =="pag"}
	end

	def presentation
		@slides.each do |slide|
			puts "\n"*(TermInfo.screen_size[0]/2)
			printf(CalculateWidth.new.execute, slide)
			puts "\n"*(TermInfo.screen_size[0]/2)
			sleep 2
		end
	end
end

class ShowSlide
	def initialize
		@slides = JSON.parse(IO.read("jobsslides.txt"))
	end

	def presentation(index)
		puts "\n"*(TermInfo.screen_size[0]/2)
		printf(CalculateWidth.new.execute, @slides["pag"+index.to_s])
		Prompt.new.show
		user_input = STDIN.getch
		if user_input == "r" and index < @slides.size
			index += 1
			Move.new.slide(index)
		elsif user_input == "l" and index > 0
			index -= 1
			Move.new.slide(index)
		elsif user_input == "r" and index == @slides.size
			system("clear")
			puts "\n"*(TermInfo.screen_size[0]/2)
			printf( CalculateWidth.new.execute, "THE END")
			puts "\n"*(TermInfo.screen_size[0]/2 - 2)
		else
			presentation(1)
		end
	end

end

class Move
	def slide(index)
		system("clear")
		ShowSlide.new.presentation(index)
	end
end

class Prompt
	def show
		puts "\n"*(TermInfo.screen_size[0]/2 - 2)
		printf( CalculateRight.new.execute, "next: For the next slide\n")
		printf( CalculateRight.new.execute, "previous: For the previous one")
	end
end

SteveTerminal.new.start