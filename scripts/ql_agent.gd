class_name QlAgent

# Largely based off of the tutorial linked in the website, altered to
# fit in Godot and to work for the game, also embedded in a class for
# organization.

# This class is only a base class for agents, different state transitions,
# rewards, states, actions, and end states may be specified by any child.

# Largely the same parameters, adapted to Godot types.
# Simple arrays are required because Godot arrays tend to
# lose their typing when manipulated, and then cause errors.
var states: int # Number of states
var actions: int # Number of actions
var rewards: Array # The reward for every state (will mostly be zeroes)
var state_transitions: Dictionary # The possible next states for each state
var initial_state: int # The state we start at
var end_states: Array # The states that could end a run, e.g. spikes or the goal
var q_table: Array # The actual Q-Table
var alpha = 0.1 # Learning rate (how much the new information impacts the Q-Table)
var gamma = 0.9 # Discout factor (money now is better than money later)
var epsilon = Game.EPSILON # Exploration factor (exploration vs. exploitation)
var decay = 0.99 # Decay rate of the exploration factor

func _init(_states: int, _actions: int, _rewards: Array, _state_transitions: Dictionary, _initial_state: int, _end_states: Array):
	# Get all of the parameters and set them, much like in Python
	states = _states
	actions = _actions
	rewards = _rewards
	state_transitions = _state_transitions
	initial_state = _initial_state
	end_states = _end_states
	# Initialize the Q-Table with all zeroes
	q_table = []
	for s in states:
		var r = []
		for a in actions:
			r.append(0.0)
		q_table.append(r)

func reset() -> void:
	# To reset, we simply revert the only values that have gotten
	# changed by training: the Q-Table and epsilon.
	epsilon = Game.EPSILON
	q_table = []
	for s in states:
		var r = []
		for a in actions:
			r.append(0.0)
		q_table.append(r)

func learn(episodes: int) -> void:
	# Follows the code in the tutorial, adapted to Godot
	for episode in range(episodes):
		# Instead of starting at a random state, we have just one to start at
		# for each episode.
		var state = initial_state
		while true: # Move until we die or reach the goal
			var action
			if randf() < epsilon: # If we decide to explore rather than exploit
				action = randi_range(0, actions-1) # Explore by picking randomly
			else:
				action = best_action(state) # Exploit by using the best action
			var next = state_transitions[state][action] # Get the next action, but don't set it yet
			var reward = rewards[next] # Get reward of next action
			# Adjust Q-Table according to Bellman's equations
			q_table[state][action] = q_table[state][action] + alpha * (
				reward + gamma * q_table[next].max() - q_table[state][action]
			)
			state = next # Now move to next state
			if state in end_states:
				break # End the episode if we reach a spike or the goal
		epsilon *= decay # Decay the exploration factor

func best_action(state: int) -> int:
	# Get the next state from the Q-Table and find it's corresponding action
	if q_table[state][0] == q_table[state][1] and q_table[state][0] == q_table[state][2]:
		# If we have all the same, we pick randomly. Otherwise, we would always
		# choose to go left if the training either didn't reach this part yet or
		# didn't modify the Q-Table here
		return randi_range(0, actions-1)
	return q_table[state].find(q_table[state].max())

func next_state(state: int) -> int:
	# Get the state that the best action points to
	return state_transitions[state][best_action(state)]

func print_q_table(rounded: bool = false) -> void:
	# Print out the Q-Table like in the tutorial code,
	# only for debugging
	for s in range(states):
		if q_table[s] == [0.0, 0.0, 0.0]:
			continue # Skip all emtpy rows
		# Round to nearest integer if rounded is true
		print("State "+str(s)+": "+str(q_table[s].map(func(x): return int(x) if rounded else x))+", best: "+str(best_action(s)))
