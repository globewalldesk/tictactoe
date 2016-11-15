game_on = true
player_score = 0
computer_score = 0
draw_games = 0

def draw_board(spaces)
  puts " ┏━━━┳━━━┳━━━┓"
  puts " ┃ #{spaces[0]} ┃ #{spaces[1]} ┃ #{spaces[2]} ┃"
  puts " ┣━━━╋━━━╋━━━┫"
  puts " ┃ #{spaces[3]} ┃ #{spaces[4]} ┃ #{spaces[5]} ┃"
  puts " ┣━━━╋━━━╋━━━┫"
  puts " ┃ #{spaces[6]} ┃ #{spaces[7]} ┃ #{spaces[8]} ┃"
  puts " ┗━━━┻━━━┻━━━┛"
end

def are_there_two_computer_tokens_in_a_row(ctoken, spaces)
  # puts "ctoken = #{ctoken}" # FOR TESTING
  # p spaces # FOR TESTING
  groovy = []
  # first row
  groovy << 2 if spaces[0] == ctoken && spaces[1] == ctoken && spaces[2] == " "
  groovy << 1 if spaces[0] == ctoken && spaces[2] == ctoken && spaces[1] == " "
  groovy << 0 if spaces[1] == ctoken && spaces[2] == ctoken && spaces[0] == " "
  # second row
  groovy << 5 if spaces[3] == ctoken && spaces[4] == ctoken && spaces[5] == " "
  groovy << 4 if spaces[3] == ctoken && spaces[5] == ctoken && spaces[4] == " "
  groovy << 3 if spaces[4] == ctoken && spaces[5] == ctoken && spaces[3] == " "
  # third row
  groovy << 8 if spaces[6] == ctoken && spaces[7] == ctoken && spaces[8] == " "
  groovy << 7 if spaces[6] == ctoken && spaces[8] == ctoken && spaces[7] == " "
  groovy << 6 if spaces[7] == ctoken && spaces[8] == ctoken && spaces[6] == " "
  # NW to SE diagonal
  groovy << 0 if spaces[4] == ctoken && spaces[8] == ctoken && spaces[0] == " "
  groovy << 4 if spaces[0] == ctoken && spaces[8] == ctoken && spaces[4] == " "
  groovy << 8 if spaces[0] == ctoken && spaces[4] == ctoken && spaces[8] == " "
  # SW to NE diagonal
  groovy << 6 if spaces[2] == ctoken && spaces[4] == ctoken && spaces[6] == " "
  groovy << 4 if spaces[2] == ctoken && spaces[6] == ctoken && spaces[4] == " "
  groovy << 2 if spaces[4] == ctoken && spaces[6] == ctoken && spaces[2] == " "
  # first column
  groovy << 0 if spaces[3] == ctoken && spaces[6] == ctoken && spaces[0] == " "
  groovy << 3 if spaces[0] == ctoken && spaces[6] == ctoken && spaces[3] == " "
  groovy << 6 if spaces[0] == ctoken && spaces[3] == ctoken && spaces[6] == " "
  # second column
  groovy << 1 if spaces[4] == ctoken && spaces[7] == ctoken && spaces[1] == " "
  groovy << 4 if spaces[1] == ctoken && spaces[7] == ctoken && spaces[4] == " "
  groovy << 7 if spaces[1] == ctoken && spaces[4] == ctoken && spaces[7] == " "
  # third column
  groovy << 2 if spaces[5] == ctoken && spaces[8] == ctoken && spaces[2] == " "
  groovy << 5 if spaces[2] == ctoken && spaces[8] == ctoken && spaces[5] == " "
  groovy << 8 if spaces[2] == ctoken && spaces[5] == ctoken && spaces[8] == " "
  # choose randomly from among winning moves
  return groovy.sample if ! groovy.empty?
  # if no conditions are met, return false
  false
end

def add_move_to_spaces(move, ctoken, spaces)
  unless spaces[move] == " "
    raise "Caught exception: trying to overwrite existing move. Fix bug!"
  end
  spaces[move] = ctoken
  return spaces
end

def block_player_now_dammit(ptoken, spaces)
  blockworthy = []
  # first row
  blockworthy << 2 if spaces[0] == ptoken && spaces[1] == ptoken && spaces[2] == " "
  blockworthy << 1 if spaces[0] == ptoken && spaces[2] == ptoken && spaces[1] == " "
  blockworthy << 0 if spaces[1] == ptoken && spaces[2] == ptoken && spaces[0] == " "
  # second row
  blockworthy << 5 if spaces[3] == ptoken && spaces[4] == ptoken && spaces[5] == " "
  blockworthy << 4 if spaces[3] == ptoken && spaces[5] == ptoken && spaces[4] == " "
  blockworthy << 3 if spaces[4] == ptoken && spaces[5] == ptoken && spaces[3] == " "
  # third row
  blockworthy << 8 if spaces[6] == ptoken && spaces[7] == ptoken && spaces[8] == " "
  blockworthy << 7 if spaces[6] == ptoken && spaces[8] == ptoken && spaces[7] == " "
  blockworthy << 6 if spaces[7] == ptoken && spaces[8] == ptoken && spaces[6] == " "
  # NW to SE diagonal
  blockworthy << 0 if spaces[4] == ptoken && spaces[8] == ptoken && spaces[0] == " "
  blockworthy << 4 if spaces[0] == ptoken && spaces[8] == ptoken && spaces[4] == " "
  blockworthy << 8 if spaces[0] == ptoken && spaces[4] == ptoken && spaces[8] == " "
  # SW to NE diagonal
  blockworthy << 6 if spaces[2] == ptoken && spaces[4] == ptoken && spaces[6] == " "
  blockworthy << 4 if spaces[2] == ptoken && spaces[6] == ptoken && spaces[4] == " "
  blockworthy << 2 if spaces[4] == ptoken && spaces[6] == ptoken && spaces[2] == " "
  # first column
  blockworthy << 0 if spaces[3] == ptoken && spaces[6] == ptoken && spaces[0] == " "
  blockworthy << 3 if spaces[0] == ptoken && spaces[6] == ptoken && spaces[3] == " "
  blockworthy << 6 if spaces[0] == ptoken && spaces[3] == ptoken && spaces[6] == " "
  # second column
  blockworthy << 1 if spaces[4] == ptoken && spaces[7] == ptoken && spaces[1] == " "
  blockworthy << 4 if spaces[1] == ptoken && spaces[7] == ptoken && spaces[4] == " "
  blockworthy << 7 if spaces[1] == ptoken && spaces[4] == ptoken && spaces[7] == " "
  # third column
  blockworthy << 2 if spaces[5] == ptoken && spaces[8] == ptoken && spaces[2] == " "
  blockworthy << 5 if spaces[2] == ptoken && spaces[8] == ptoken && spaces[5] == " "
  blockworthy << 8 if spaces[2] == ptoken && spaces[5] == ptoken && spaces[8] == " "
  # choose randomly from among available blocks
  return blockworthy.sample if ! blockworthy.empty?
  # if no conditions are met, return false
  false
end

# count up number of two-in-a-rows; return it
def does_a_fork_now_exist(ctoken, spaces)
  two_in_a_row = 0
  # first row
  two_in_a_row += 1  if spaces[0] == ctoken && spaces[1] == ctoken && spaces[2] == " "
  two_in_a_row += 1  if spaces[0] == ctoken && spaces[2] == ctoken && spaces[1] == " "
  two_in_a_row += 1  if spaces[1] == ctoken && spaces[2] == ctoken && spaces[0] == " "
  # second row
  two_in_a_row += 1  if spaces[3] == ctoken && spaces[4] == ctoken && spaces[5] == " "
  two_in_a_row += 1  if spaces[3] == ctoken && spaces[5] == ctoken && spaces[4] == " "
  two_in_a_row += 1  if spaces[4] == ctoken && spaces[5] == ctoken && spaces[3] == " "
  # third row
  two_in_a_row += 1  if spaces[6] == ctoken && spaces[7] == ctoken && spaces[8] == " "
  two_in_a_row += 1  if spaces[6] == ctoken && spaces[8] == ctoken && spaces[7] == " "
  two_in_a_row += 1  if spaces[7] == ctoken && spaces[8] == ctoken && spaces[6] == " "
  # NW to SE diagonal
  two_in_a_row += 1  if spaces[4] == ctoken && spaces[8] == ctoken && spaces[0] == " "
  two_in_a_row += 1  if spaces[0] == ctoken && spaces[8] == ctoken && spaces[4] == " "
  two_in_a_row += 1  if spaces[0] == ctoken && spaces[4] == ctoken && spaces[8] == " "
  # SW to NE diagonal
  two_in_a_row += 1  if spaces[2] == ctoken && spaces[4] == ctoken && spaces[6] == " "
  two_in_a_row += 1  if spaces[2] == ctoken && spaces[6] == ctoken && spaces[4] == " "
  two_in_a_row += 1  if spaces[4] == ctoken && spaces[6] == ctoken && spaces[2] == " "
  # first column
  two_in_a_row += 1  if spaces[3] == ctoken && spaces[6] == ctoken && spaces[0] == " "
  two_in_a_row += 1  if spaces[0] == ctoken && spaces[6] == ctoken && spaces[3] == " "
  two_in_a_row += 1  if spaces[0] == ctoken && spaces[3] == ctoken && spaces[6] == " "
  # second column
  two_in_a_row += 1  if spaces[4] == ctoken && spaces[7] == ctoken && spaces[1] == " "
  two_in_a_row += 1  if spaces[1] == ctoken && spaces[7] == ctoken && spaces[4] == " "
  two_in_a_row += 1  if spaces[1] == ctoken && spaces[4] == ctoken && spaces[7] == " "
  # third column
  two_in_a_row += 1  if spaces[5] == ctoken && spaces[8] == ctoken && spaces[2] == " "
  two_in_a_row += 1  if spaces[2] == ctoken && spaces[8] == ctoken && spaces[5] == " "
  two_in_a_row += 1  if spaces[2] == ctoken && spaces[5] == ctoken && spaces[8] == " "

  return two_in_a_row
end

# returns a list of spaces array indexes that == " "
def compile_open_spaces(spaces)
  # Compile list of open spaces
  index = 0
  open_spaces = []
  spaces.each do |space|
    open_spaces << index if space == " "
    index += 1
  end
  return open_spaces
end

# Test each space: if it is filled in, then test
# are_there_two_computer_tokens_in_a_row. If yes, move there.
def discover_fork(ctoken, spaces)
  open_spaces = compile_open_spaces(spaces)

  # Cycle through open_spaces; temporarily add a token to spaces;
  # then determine if there are two instances of two computer tokens
  # in a row.
  avail = [] # array of fork-creating spaces, to maximize randomness of play
  open_spaces.each do |space|
    # assigns computer token to this empty space
    spaces[space] = ctoken
    # check if spaces now contains a fork!
    fork_me = does_a_fork_now_exist(ctoken, spaces)
    spaces[space] = " "
    avail << space if fork_me > 1 # add this space to array of fork-creating spaces
  end
  return avail.sample if ! avail.empty?
  return false # if no forks were found
end

# Check to see if player has chosen a corner that has an open opposite.
def try_opposite_corner(ptoken, spaces)
  # Check for player corner moves; then check if opposite is open; return if so
  avail = []
  avail << 8 if spaces[0] == ptoken && spaces[8] == " "
  avail << 0 if spaces[8] == ptoken && spaces[0] == " "
  avail << 2 if spaces[6] == ptoken && spaces[2] == " "
  avail << 6 if spaces[2] == ptoken && spaces[6] == " "
  return avail.sample if ! avail.empty?
  return false # if you can't jump on an opposite corner
end

# Simply occupy any empty corner
def try_empty_corner(spaces)
  avail = [] # create array of empty corners
  avail << 0 if spaces[0] == " "
  avail << 2 if spaces[2] == " "
  avail << 6 if spaces[6] == " "
  avail << 8 if spaces[8] == " "
  return avail.sample if ! avail.empty? # sample the empty corner array
  return false # if all corners are occupied
end

# Simply occupy any empty side
def play_empty_side(spaces)
  avail = []
  avail << 1 if spaces[1] == " "
  avail << 3 if spaces[3] == " "
  avail << 5 if spaces[5] == " "
  avail << 7 if spaces[7] == " "
  return avail.sample if ! avail.empty?
  return false # if all sides are occupied
end

# The big AI, borrowed from Wikipedia via Stack Overflow; test if a move is
# generated by any of these tests; one should be by the end of the method.
# The original AI shouldn't be able to be beaten.
def computer_moves(winnable, ptoken, ctoken, spaces)
  skip_rule = ""
  if winnable == 'y'
    skip_rule = [0, 1, 2, 3, 5].sample # randomly chooses a rule to "forget"
  end
  puts "Computer's move."
  # Test each set of conditions; until a move is found
  move = false

  # Win: If you have two in a row, play the third to get three in a row.
  # puts "Trying 1"
  move = are_there_two_computer_tokens_in_a_row(ctoken, spaces) unless skip_rule == 0
  if move
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # Block: If the opponent has two in a row, play the third to block them.
  # puts "Trying 2"
  move = block_player_now_dammit(ptoken, spaces) unless skip_rule == 1
  if move
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # Fork: Create an opportunity where you can win in two ways.
  # puts "Trying 3"
  move = discover_fork(ctoken, spaces) unless skip_rule == 2
  if move
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # Block Opponent's Fork: If there is a configuration where the opponent
  # can fork, block that fork.
  # It appears I can simply use discover_fork again, changing only ctoken
  # to ptoken!
  # puts "Trying 4"
  move = discover_fork(ptoken, spaces) unless skip_rule == 3
  if move
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # Center: Play the center.
  # puts "Trying 5"
  # Note, no "unless skip_rule == 4" here. This is because if it's the opening
  # move, and this rule is skipped, then the computer won't play anything.
  if spaces[4] == " " # i.e., if the center is open, and you've made it this far
    spaces = add_move_to_spaces(4, ctoken, spaces)
    return spaces
  end

  # Opposite Corner: If the opponent is in the corner, play the opposite corner.
  # puts "Trying 6"
  if move
    move = try_opposite_corner(ptoken, spaces) unless skip_rule == 5
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # Empty Corner: Play an empty corner.
  # puts "Trying 7"
  move = try_empty_corner(spaces)
  if move
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # Empty Side: Play an empty side.
  # puts "Trying 8"
  move = play_empty_side(spaces)
  if move
    spaces = add_move_to_spaces(move, ctoken, spaces)
    return spaces
  end

  # If move is still false, game is over!

  return spaces
end

def player_moves(ptoken, spaces)
  puts "Your move."
  valid_answer = nil
  answer = ""
  until valid_answer do
    print "Enter 1-9 to mark an #{ptoken}: "
    answer = gets.chomp.to_i
    if ! (1..9).to_a.include?(answer)
      puts "Please choose a number, 1 through 9:"
      puts " ┏━━━┳━━━┳━━━┓"
      puts " ┃ 1 ┃ 2 ┃ 3 ┃"
      puts " ┣━━━╋━━━╋━━━┫"
      puts " ┃ 4 ┃ 5 ┃ 6 ┃"
      puts " ┣━━━╋━━━╋━━━┫"
      puts " ┃ 7 ┃ 8 ┃ 9 ┃"
      puts " ┗━━━┻━━━┻━━━┛"
      next
    end
    # Prepare list of acceptable spaces
    open_spaces = compile_open_spaces(spaces)
    if ! open_spaces.include?(answer - 1)
      puts "An '#{spaces[answer - 1]}' is already in that spot. Try again."
      next
    end
    valid_answer = true # if you've gotten this far, the answer is valid
  end
  # Actually write player's move to board!
  spaces[answer - 1] = ptoken
  return spaces
end

# is there three in a row yet?
def three_in_a_row(token, spaces)
  if (spaces[0] == token && spaces[1] == token && spaces [2] == token) ||
    (spaces[3] == token && spaces[4] == token && spaces [5] == token) ||
    (spaces[6] == token && spaces[7] == token && spaces [8] == token) ||
    (spaces[0] == token && spaces[3] == token && spaces [6] == token) ||
    (spaces[1] == token && spaces[4] == token && spaces [7] == token) ||
    (spaces[2] == token && spaces[5] == token && spaces [8] == token) ||
    (spaces[0] == token && spaces[4] == token && spaces [8] == token) ||
    (spaces[6] == token && spaces[4] == token && spaces [2] == token)
    return true
  end
  return false # return false if not three in a row yet
end

system("cls")

#####################################################

# Enclosing loop (multiple games)
while game_on
  puts "\n\nStarting a new game of Tic-Tac-Toe!"
  winnable ||= nil
  unless winnable # don't check winnability every time
    print "Do you want the game to be winnable? (y/n) "
    winnable = gets.chomp
    if winnable == 'y'
      puts "OK, game will (sometimes) be winnable."
    else
      puts "OK, the best you'll be able to get is a draw."
    end
  end
  present_round_not_won = true
  player_wins = nil # true if player wins; false if computer wins
  # Start game by creating spaces
  spaces = Array.new(9, " ")

  # See who goes first and announce
  who_goes_first = (rand > 0.5) # outputs random "true" or "false"
  draw_board(spaces)
  puts (who_goes_first == true ? "Computer" : "Player") + " goes first."
  whose_move = who_goes_first # computer moves (and moves first) when true
  # Determine if computer and player are X and O, or O and X
  ctoken, ptoken = (who_goes_first == true ? ["X", "O"] : ["O", "X"] )

####################################################

  # Inner enclosing loop (present game)
  while present_round_not_won
    # move, then toggle who moves
    if whose_move == true
      spaces = computer_moves(winnable, ptoken, ctoken, spaces)
    else
      spaces = player_moves(ptoken, spaces)
    end
    whose_move = !whose_move

    # redraw board following move
    draw_board(spaces)

    # Determine if there's a winner
    if three_in_a_row(ptoken, spaces) == true
      puts "Player wins this game!"
      present_round_not_won = false
      player_wins = true
    elsif three_in_a_row(ctoken, spaces) == true
      puts "Computer wins this game!"
      present_round_not_won = false
      player_wins = false
    elsif ! spaces.include?(" ")
      present_round_not_won = false
      puts "Drawn game!"
      present_round_not_won = false
      player_wins = nil
    end

  end # of present_round_not_won

  # Increment score
  if player_wins == true
    player_score += 1
  elsif player_wins == false
    computer_score += 1
  else
    draw_games += 1
  end

  # Announce score
  puts "Score is:"
  puts "  Player: #{player_score}"
  puts "  Computer: #{computer_score}"
  puts "  Drawn games: #{draw_games}\n"

  # Invite a new game
  answer = ""
  until answer == 'y' || answer == 'n'
    print "New game? (y)es or (n)o: "
    answer = gets.chomp
    puts "Only y or n, please." unless answer == 'y' or answer == 'n'
    puts "OK, so long!" if answer == 'n'
  end

  game_on = (answer == 'y' ? true : false)

end # of enclosing loop (multiple games)
