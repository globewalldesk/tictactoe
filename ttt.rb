require 'colorize'
game_on = true
player_score = 0
computer_score = 0
draw_games = 0

def create_board(spaces)
    board = {
      row1: {0 => spaces[0], 1 => spaces[1], 2 => spaces[2]}, # hash of three row spaces
      row2: {3 => spaces[3], 4 => spaces[4], 5 => spaces[5]},
      row3: {6 => spaces[6], 7 => spaces[7], 8 => spaces[8]},
      col1: {0 => spaces[0], 3 => spaces[3], 6 => spaces[6]}, # hash of three column spaces
      col2: {1 => spaces[1], 4 => spaces[4], 7 => spaces[7]},
      col3: {2 => spaces[2], 5 => spaces[5], 8 => spaces[8]},
      diag1: {0 => spaces[0], 4 => spaces[4], 8 => spaces[8]}, # hash of nw-se diagonal spaces
      diag2: {2 => spaces[2], 4 => spaces[4], 6 => spaces[6]}    }
    return board
end

def draw_board(spaces)
  puts " ┏━━━━━━━┳━━━━━━━┳━━━━━━━┓"
  puts " ┃       ┃       ┃       ┃"
  puts " ┃   #{spaces[0] == " " ? "1".red : spaces[0]}   ┃   #{spaces[1] == " " ? "2".red : spaces[1]}   ┃   #{spaces[2] == " " ? "3".red : spaces[2]}   ┃"
  puts " ┃       ┃       ┃       ┃"
  puts " ┣━━━━━━━╋━━━━━━━╋━━━━━━━┫"
  puts " ┃       ┃       ┃       ┃"
  puts " ┃   #{spaces[3] == " " ? "4".red : spaces[3]}   ┃   #{spaces[4] == " " ? "5".red : spaces[4]}   ┃   #{spaces[5] == " " ? "6".red : spaces[5]}   ┃"
  puts " ┃       ┃       ┃       ┃"
  puts " ┣━━━━━━━╋━━━━━━━╋━━━━━━━┫"
  puts " ┃       ┃       ┃       ┃"
  puts " ┃   #{spaces[6] == " " ? "7".red : spaces[6]}   ┃   #{spaces[7] == " " ? "8".red : spaces[7]}   ┃   #{spaces[8] == " " ? "9".red : spaces[8]}   ┃"
  puts " ┃       ┃       ┃       ┃"
  puts " ┗━━━━━━━┻━━━━━━━┻━━━━━━━┛"
end

def are_there_two_computer_tokens_in_a_row(ctoken, spaces, board)
  groovy = [] # array of winning moves
  # Strategy: since there is already a hash of all triads, simply process
  # the hash; for each triad, test if it contains two ctokens and one " ".
  # If so, return the # for that space.
  board.each do |triad, thash|
    ctokens_spotted = 0 # count the ctokens
    empty_spotted = false # look for an empty spot
    empty = nil # any empty space
    thash.each do |spacenum, content|
      ctokens_spotted += 1 if content == ctoken
      if content == " "
        empty_spotted = true
        empty = spacenum
      end
      # The essential logic: if you spot an empty space in a triad, along with
      # two computer tokens, then add the empty space to the array of groovies!
      if empty_spotted == true && ctokens_spotted == 2
        groovy << empty
      end
    end
  end # of examination of board
  return groovy.sample, groovy.length if ! groovy.empty?
  # if no conditions are met, return false
  false
end

def add_move_to_spaces(move, ctoken, spaces, board)
  unless spaces[move] == " "
    raise "Caught exception: trying to overwrite existing move. Fix bug!"
  end
  spaces[move] = ctoken
  board = create_board(spaces)
  return spaces, board
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
def discover_fork(ctoken, spaces, board)
  open_spaces = compile_open_spaces(spaces)

  # Cycle through open_spaces; temporarily add a token to spaces;
  # then determine if there are two instances of two computer tokens
  # in a row.
  avail = [] # array of fork-creating spaces, to maximize randomness of play
  open_spaces.each do |space|
    # assigns computer token to this empty space
    spaces[space] = ctoken
    # check if spaces now contains a fork!
    afork, length = are_there_two_computer_tokens_in_a_row(ctoken, spaces, board)
    spaces[space] = " "
    avail << space if length && length > 1 # add this space to array of fork-creating spaces
  end
  if ! avail.empty? # do this if there ARE available fork-creating spaces
    corners = avail.select {|x| [0, 2, 6, 8].include?(x)}
    return corners.sample if ! corners.empty? # gimme any corner blocker first
    return avail.sample # then other kinds of blockers
  end
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
def computer_moves(winnable, ptoken, ctoken, spaces, board)
  skip_rule = ""
  if winnable == 'y'
    skip_rule = [0, 1, 2, 3, 5].sample # randomly chooses a rule to "forget"
  end
  system("cls")
  puts "Computer's move."
  # Test each set of conditions; until a move is found
  move = false

  # Win: If you have two in a row, play the third to get three in a row.
  # puts "Trying 1"
  move, length = are_there_two_computer_tokens_in_a_row(ctoken, spaces, board) unless skip_rule == 0
  if move
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # Block: If the opponent has two in a row, play the third to block them.
  # puts "Trying 2"
  move, length = are_there_two_computer_tokens_in_a_row(ptoken, spaces, board) unless skip_rule == 1
  if move
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # Fork: Create an opportunity where you can win in two ways.
  # puts "Trying 3"
  move = discover_fork(ctoken, spaces, board) unless skip_rule == 2
  if move
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # Block Opponent's Fork: If there is a configuration where the opponent
  # can fork, block that fork.
  # It appears I can simply use discover_fork again, changing only ctoken
  # to ptoken!
  # puts "Trying 4"
  move = discover_fork(ptoken, spaces, board) unless skip_rule == 3
  if move
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # Center: Play the center.
  # puts "Trying 5"
  # Note, no "unless skip_rule == 4" here. This is because if it's the opening
  # move, and this rule is skipped, then the computer won't play anything.
  if spaces[4] == " " # i.e., if the center is open, and you've made it this far
    spaces, board = add_move_to_spaces(4, ctoken, spaces, board)
    return spaces, board
  end

  # Opposite Corner: If the opponent is in the corner, play the opposite corner.
  # puts "Trying 6"
  if move
    move = try_opposite_corner(ptoken, spaces) unless skip_rule == 5
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # Empty Corner: Play an empty corner.
  # puts "Trying 7"
  move = try_empty_corner(spaces)
  if move
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # Empty Side: Play an empty side.
  # puts "Trying 8"
  move = play_empty_side(spaces)
  if move
    spaces, board = add_move_to_spaces(move, ctoken, spaces, board)
    return spaces, board
  end

  # If move is still false, game is over!

  return spaces, board
end

def player_moves(ptoken, spaces, board)
  puts "Your move."
  valid_answer = nil
  answer = ""
  until valid_answer do
    print "Place an #{ptoken}: "
    answer = gets.chomp.to_i
    if ! (1..9).to_a.include?(answer)
      puts "Please choose a number, 1 through 9:"
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
  board = create_board(spaces)
  return spaces, board
end

# is there three in a row yet?
def three_in_a_row(token, board)
  board.each do |triad, thash|
    if thash.values.all? { |value| value == token}
      return true # returns true (won game) if seen once
    end
  end
  return false # return false if not three in a row yet
end

system("cls")

#####################################################

# Enclosing loop (multiple games)
while game_on
  system("cls")
  puts "Starting a new game of Tic-Tac-Toe!"
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
  # converts spaces into handy hash of different configurations of spaces
  # absolutely necessary for more elegant AI, e.g., to see if exactly one
  # space in a triad is available & would result in a win.
  board = create_board(spaces)

  # See who goes first and announce
  who_goes_first = (rand > 0.5) # outputs random "true" or "false"
  draw_board(spaces) if who_goes_first == false
  puts (who_goes_first == true ? "Computer" : "Player") + " goes first."
  whose_move = who_goes_first # computer moves (and moves first) when true
  # Determine if computer and player are X and O, or O and X
  ctoken, ptoken = (who_goes_first == true ? ["X", "O"] : ["O", "X"] )

####################################################

  # Inner enclosing loop (present game)
  while present_round_not_won
    # move, then toggle who moves
    if whose_move == true
      spaces, board = computer_moves(winnable, ptoken, ctoken, spaces, board)
    else
      spaces, board = player_moves(ptoken, spaces, board)
    end
    whose_move = !whose_move # toggles true/false to determine whose move it is

    # redraw board following move
    draw_board(spaces)

    # Determine if there's a winner
    if three_in_a_row(ptoken, board) == true
      puts "Player wins this game!"
      present_round_not_won = false
      player_wins = true
    elsif three_in_a_row(ctoken, board) == true
      puts "Computer wins this game!"
      present_round_not_won = false
      player_wins = false
    elsif ! spaces.include?(" ")
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
