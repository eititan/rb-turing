#!/usr/bin/env ruby
# Author: John Hutchins
# Turing Machine in Ruby

if ARGV.length < 2 || ARGV.length > 2
	puts "Usage: ./turing.rb <TMAsciiFile> \"WORD\"\n"
	exit(1)
end

file = ARGV[0]
@word = ARGV[1]
@tapePointer = 0

def acceptWord()
        puts "Accepted: " + @word
        exit(0)
end

def rejectWord()
        puts "Rejected: " + @word
        exit(0)
end

def handleTapePointer(direction)
        if direction.include? "R"
		@tapePointer += 1
        elsif direction.include? "L" and @tapePointer > 0
                @tapePointer -= 1
        else
                rejectWord
        end
end

def changeTapeLetter(newLetter, index, oldTape)
	newTape = oldTape
	newTape[index] = newLetter
	return newTape
end

def checkIfEndOfTape(tape)
	if @tapePointer + 1 > tape.length
		tape = tape + "_"
	end

	return tape
end 

transitions = []
if File.exists?(file) 
	File.foreach(file){	|line|
		if line.include? "#"
			next
		end

		transitions << line
	}
else
	puts "File: " + file + " could not be found."
	exit(1)
end

#start to digest word
count = 0
tape = @word
letterUpInTape = tape[0]
toState = "Start"

while count < 1000

	#state = transitions[0].split(', ')
	for t in transitions do	
		state = t.split(', ')
		
		if toState.include? "Halt"
			acceptWord
		end
	
		## checking if there is transition
		# if from current state = to state AND transition letter = state letter 
		if state[0].include? toState and letterUpInTape.eql? state[1]
			
			tape = changeTapeLetter(state[2], @tapePointer, tape.dup)	#replace old letter on tape w/ new letter
			handleTapePointer(state[3])					#changes the tape pointer based on direction			                      
			tape = checkIfEndOfTape(tape.dup)				#after head updates, check if end of tape
			letterUpInTape = tape[@tapePointer]				#gets new word to be checked
                        toState = state[4].strip					#changes the next "to-state" to state of this transition

			#puts tape
			break
		end
	end

	count += 1
end

rejectWord
