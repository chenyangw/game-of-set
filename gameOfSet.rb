#
# The game of Set
#
# @author: Tania Prince, Chenyang Wang, Dragan Pantic, 
# Cameron Mitchell, and Daniel White 
#

# Classes --------------------------------------------------------------------------

# card class - use these strings when initializing cards:
# red, green, purple, diamond, squiggle, oval, filled, empty, lined,  1, 2, 3
class Card
    attr_accessor :color, :symbol, :fill, :number
	def initialize (color, symbol, fill, number)
	    @color = color
	    @symbol = symbol
	    @fill = fill
	    @number = number
	end
    def to_s
           " #{@color}, #{@symbol}, #{@fill}, #{@number}\n"
    end
end

# Methods --------------------------------------------------------------------------

# Generates deck and shuffles cards
def generate (cards)
	# Card types
    colors = %w{red green purple}
    symbols = %w{diamond squiggle oval}
    fills = %w{filled empty lined}
    numbers = %w{1 2 3}

    # Dynamically generate set of cards
    #for i in 0..2 dont know why two decks are created
    colors.each do |colors|
        symbols.each do |symbols|
            fills.each do |fills|
                numbers.each do |numbers|
                    cards.push(Card.new(colors, symbols, fills, numbers))
                end
            end
        end    
    end
    cards.shuffle!          

end

# Takes top card from the deck, adds it to the 
# table and displays card
def deal (cards, table)
	card = cards.shift
	table.push card
	printf "%8s %10s %7s %3s ", card.color, card.symbol, card.fill, card.number
end

#returns true if all parameters are the same 
#or all parameters are different
def allSameOrDifferent? (feature1, feature2, feature3)
	result = false
	
	if(feature1 == feature2 && feature2 == feature3)
		result = true
	elsif(feature1 != feature2 && feature1 != feature3 && feature2 != feature3)
		result = true
	end
		
	return result
end

# Returns true if set is valid, false otherwise
def verify (card1, card2, card3)
	
	return allSameOrDifferent?(card1.color, card2.color, card3.color) &&
		allSameOrDifferent?(card1.symbol, card2.symbol, card3.symbol) &&
		allSameOrDifferent?(card1.fill, card2.fill, card3.fill) &&
		allSameOrDifferent?(card1.number, card2.number, card3.number) 
		
end

# Keeps track of player scores
# playerNumber: id of the player; 
# score: the array tracking all players score;
# pscore: scores to be added to this player
def calcScore(playerNumber, score, pscore)
	newscore = score.at(playerNumber-1) + pscore
	score[playerNumber-1] = newscore
end

# Calculates and displays the winner. Should check
# to see if there is a tie.
# This method display all players who get the highest score
# score: array storing all players score
def winner(score)
  max = score.sort {|x,y| y <=> x }.at(0)
    puts("Max score is: #{max} ")
    puts ""
    puts("Winner")
    puts "---------------------------------"
    count = 0
  for count in 0..(score.length-1)
      if score.at(count) == max
        puts("Player #{count+1}")
      end
  end
end

# Checks to see if card is on table
def onTable(table, card)
	result = false
	for i in 0...table.length
		if card.color == table[i].color && 
			card.symbol == table[i]. symbol && 
			card.fill == table[i].fill &&
			card.number == table[i].number
			result = true
		end
	end
	return result
end

# Returns how many  different sets are available in the cards
# table: the array contains 12 cards on the table
def hint (table) 
    count = 0   
    for i in 0..table.size-3
        for j in (i+1)..table.size-2
            for k in (j+1)..table.size-1
                if (verify(table.at(i),table.at(j),table.at(k)))
                    count += 1
                end
            end
        end
    end    
    return count
end


# Main ---------------------------------------------------------------------

cards = Array.new() # deck of cards
table = Array.new() # cards on the table
score = Array.new() # player scores
players = 0 # number of players
playerNumber = 0 # player number
input = '' # user input: 's' for set or 'enter' for the next card
missed = 0 # number of times player has missed a set

puts "Welcome to the game of Set"

# Get number of players and validate input
loop do
	print "How many players are there? " 
	players = gets.to_i
	break if players >= 2 and players <= 12
	puts "Invalid input. Enter an integer from 2 to 12."
end

# Initialize scores
for i in 0...players
	score[i] = 0
end

# Set up card deck
generate(cards)

# Start game
puts ""
puts "Type 's' for set or 'enter' for the next card"
puts ""
puts "Cards on table"
puts "---------------------------------"

while cards.length > 0 do

	# Deal cards one at a time until 12 are on the table
	if table.length < 12
		deal(cards, table)
	else
		deal(cards, table)
		puts ""
		deal(cards, table)
		puts ""
		deal(cards, table)
	end

	# If the players miss a set more than 3 times then
	# give them a hint
	if hint(table) > 0
		missed += 1
	end
	if missed == 3
		if hint(table) == 1
			print "\n\nHINT: There is #{hint(table)} possible set on the table \n"
		else
			print "\n\nHINT: There are #{hint(table)} possible sets on the table \n"
		end
		missed = 0
	end

	# Check for set or next card
	input = gets.chomp
	
	# If the player calls set then check it's validity
	if input == 's'

	puts ""
	puts "Set!"

		# Indentify player
		loop do
			print "What is your player number? "
			playerNumber = gets.to_i
			break if playerNumber >= 1 and playerNumber <= players
			puts "Invalid player. Enter a player from 1 to #{players}"
		end

		# Identify cards
		first, second, third = Array.new()
		loop do
			puts ""
			puts "Enter cards in the following format: color symbol fill number"
			puts "Enter card 1: "
			first = gets.chomp.split
			puts "Enter card 2: "
			second = gets.chomp.split
			puts "Enter card 3: "
			third = gets.chomp.split
			puts ""
			puts "You entered"
			puts "#{first[0]} #{first[1]} #{first[2]} #{first[3]}"
			puts "#{second[0]} #{second[1]} #{second[2]} #{second[3]}"
			puts "#{third[0]} #{third[1]} #{third[2]} #{third[3]}"
			print "Is this correct? (y/n): "
			answer = gets.chomp
			break if answer == 'y'
		end
		card1 = Card.new(first[0], first[1], first[2], first[3])
		card2 = Card.new(second[0], second[1], second[2], second[3])
		card3 = Card.new(third[0], third[1], third[2], third[3])

		# Make sure that card is on the table
		onTable = onTable(table, card1) && onTable(table, card2) && onTable(table, card3)

		# Make sure cards are unique
		notUnique = card1 == card2 || card2 == card3 || card1 == card3
	
		if onTable == true && notUnique == false
			# If the set is valid
			if verify(card1, card2, card3) == true

				# Display result
				puts ""
				puts "Valid set. Player #{playerNumber} gets 1 point."

				# Increment score
				calcScore(playerNumber, score, 1)

				# Remove 3 cards from the table
				table.delete(card1)
				table.delete(card2)
				table.delete(card3)

				# Display remaining cards
				puts ""
				print "Press enter to continue"
				input = gets.chomp
				puts ""
				puts "Type 's' for set or 'enter' for the next card"
				puts ""
				puts "Cards on table"
				puts "---------------------------------"
				for i in 0...table.length
					puts ""
					printf "%8s %10s %7s %3s ", table[i].color, table[i].symbol, table[i].fill, table[i].number
				end
				puts ""
				puts "\nDealing\n\n"

			end

			# If the set is invalid
			if verify(card1, card2, card3) == false

				# Display result
				puts "Invalid set. Player #{playerNumber} loses 1 point."

				# Decrement score
				calcScore(playerNumber, score, -1)

				# Display remaining cards
				puts ""
				print "Press enter to continue"
				input = gets.chomp
				puts ""
				puts "Type 's' for set or 'enter' for the next card"
				puts ""
				puts "Cards on table"
				puts "---------------------------------"
				for i in 0...table.length
					puts ""
					printf "%8s %10s %7s %3s ", table[i].color, table[i].symbol, table[i].fill, table[i].number
				end
				puts ""
				puts "\nDealing\n\n"

			end

		else
			puts ""
			puts "Sorry but those cards are not on the table!"
			# Display remaining cards
			puts ""
			print "Press enter to continue"
			input = gets.chomp
			puts ""
			puts "Type 's' for set or 'enter' for the next card"
			puts ""
			puts "Cards on table"
			puts "---------------------------------"
			for i in 0...table.length
				puts ""
				printf "%8s %10s %7s %3s ", table[i].color, table[i].symbol, table[i].fill, table[i].number
			end
			puts ""
			puts "\nDealing\n\n"
		end

	end
	
end

puts ""
puts "Game over. There are no more cards left in the deck."

# Display final scores
puts ""
puts "Final Scores"
puts puts "---------------------------------"
for i in 0...players
	puts "Player #{i + 1}: #{score[i]}"
end
puts ""

# Calculate winner
winner(score)