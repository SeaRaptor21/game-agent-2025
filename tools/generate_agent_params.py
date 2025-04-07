import numpy as np

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
    ######G##
    #########
""".strip().splitlines()]
joined = "".join(board)
width = len(board[0])
height = len(board)
states = width*height
state_transitions = {}
for s in range(states):
    if joined[s] == '#':
        continue
    col = s % width
    row = s // width
    #print(s, row, col)
    state_transitions[s] = [
        s+width-1 if col>0 else s+width if row+1<height else s,
        s+width if row+1<height else s,
        s+width+1 if col+1<width else s+width if row+1<height else s
    ]
    alt = s+width if joined[s+width] != '#' else s+width-1 if joined[s+width-1] != '#' else s+width+1 if joined[s+width+1] != '#' else s-1 if joined[s-1] != '#' else s+1 if joined[s+1] != '#' else s
    state_transitions[s] = [x if joined[x] != '#' else alt for x in state_transitions[s]]
    if joined[s] == '<':
        state_transitions[s] = [s+width-(1 if joined[s+width-1] != '#' else 0)]*3
    elif joined[s] == '>':
        state_transitions[s] = [s+width+(1 if joined[s+width-1] != '#' else 0)]*3
rewards = [0.0]*states
end_states = []
for i, c in enumerate(joined):
    if c in "L^":
        rewards[i] = -10.0
        end_states.append(i)
    elif c == 'G':
        rewards[i] = 10.0
        end_states.append(i)

print("\n".join([x.strip() for x in """
    const STATES = {}
    const ACTIONS = {}
    const REWARDS = {}
    const STATE_TRANSITIONS = {}
    const INITIAL_STATE = {}
    const END_STATES = {}
""".strip().splitlines()]).format(states, 3, rewards, state_transitions, 23, end_states))