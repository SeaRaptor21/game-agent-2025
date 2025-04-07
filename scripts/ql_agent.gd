class_name QlAgent

var states: int
var actions: int
var rewards: Array
var state_transitions: Dictionary
var initial_state: int
var end_states: Array
var q_table: Array
var alpha = 0.1
var gamma = 0.9
var epsilon = 0.8
var decay = 0.99

func _init(_states: int, _actions: int, _rewards: Array, _state_transitions: Dictionary, _initial_state: int, _end_states: Array):
	states = _states
	actions = _actions
	rewards = _rewards
	state_transitions = _state_transitions
	initial_state = _initial_state
	end_states = _end_states
	q_table = [] #np.zeros(states, actions)
	for s in states:
		var r = []
		for a in actions:
			r.append(0.0)
		q_table.append(r)

func learn(episodes: int) -> void:
	for episode in range(episodes):
		var state = initial_state
		while true:
			var action
			if randf() < epsilon:
				action = randi_range(0, actions-1)
			else:
				action = best_action(state)
			var next = state_transitions[state][action]
			var reward = rewards[next]
			q_table[state][action] = q_table[state][action] + alpha * (
				reward + gamma * q_table[next].max() - q_table[state][action]
			)
			state = next
			if state in end_states:
				break
		epsilon *= decay

func best_action(state: int) -> int:
	return q_table[state].find(q_table[state].max())

func next_state(state: int) -> int:
	return state_transitions[state][best_action(state)]

func print_q_table(rounded: bool = false) -> void:
	for s in range(states):
		if q_table[s] == [0.0, 0.0, 0.0]:
			continue
		print("State "+str(s)+": "+str(q_table[s].map(func(x): return int(x) if rounded else x))+", best: "+str(best_action(s)))
