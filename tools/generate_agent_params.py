# See scripts/game.gd for an explanation of this file

# Key:
#  - # is a wall
#  - ^ is a spike
#  - G is the goal
#  - < or > is wind

board = [x.strip() for x in """
    #########
    #########
    ## #  ###
    ## # ####
    ##>>>>>##
    ##     ##
    ##    ^##
    ##  ^  ##
    ###^#  ##
    #####  ##
    ##<<<<<##
    ##<<<<<##
    ###^<<<##
    ##     ##
    ##     ##
    ##^^   ##
    ###### ##
    ##<^<<<##
    ####^  ##
    ####^<<##
    ####^  ##
    ##    ^##
    ## ^^ ###
    ## ##  ##
    ##     ##
    ##    ^##
    ##   ^###
    ##   ####
    ##     ##
    ##^   ^##
    ####G####
    #########
""".strip().splitlines()] # Start with string representation, split into rows
joined = "".join(board) # Join them all together to index for states
width = len(board[0])
height = len(board)
states = width*height
state_transitions = {}
for s in range(states):
    # Create the state transitions for each state
    if joined[s] == '#':
        continue # Ignore if it's a wall
    col = s % width
    row = s // width
    state_transitions[s] = [
        s+width-1 if col>0 else s+width if row+1<height else s, # Left and down if possible, then down, then nothing
        s+width if row+1<height else s, # Down if possible, then nothing
        s+width+1 if col+1<width else s+width if row+1<height else s # Down and right if possible, then down, then nothing
    ]
    # Alternates for if the action would move us into a wall
    alt = s+width if joined[s+width] != '#' else s+width-1 if joined[s+width-1] != '#' else s+width+1 if joined[s+width+1] != '#' else s-1 if joined[s-1] != '#' else s+1 if joined[s+1] != '#' else s
    # Use the alternate if we would otherwise be in a wall
    state_transitions[s] = [x if joined[x] != '#' else alt for x in state_transitions[s]]
    if joined[s] == '<':
        # Just always go left if there's wind blowing left
        state_transitions[s] = [s+width-(1 if joined[s+width-1] != '#' else 0)]*3
    elif joined[s] == '>':
        # Just always go right if there's wind blowing right
        state_transitions[s] = [s+width+(1 if joined[s+width-1] != '#' else 0)]*3
rewards = [0.0]*states # Start with no rewards
end_states = [] # Start with no end states
for i, c in enumerate(joined):
    if c == '^': # Spikes
        rewards[i] = -10.0
        end_states.append(i)
    elif c == 'G': # Goal
        rewards[i] = 10.0
        end_states.append(i)

# Print out the values ready to be pasted into game.gd
print("\n".join([x.strip() for x in """
    const STATES = {}
    const ACTIONS = {}
    const REWARDS = {}
    const STATE_TRANSITIONS = {}
    const INITIAL_STATE = {}
    const END_STATES = {}
""".strip().splitlines()]).format(states, 3, rewards, state_transitions, 23, end_states))