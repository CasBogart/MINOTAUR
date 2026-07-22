class_name StateMachine extends Node

@export var INITIAL_STATE: State
var current_state: State

func init(parent):
	
	# Initialize parent (State Machine) for each state
	
	for child in get_children():
		if child is State:
			child.parent = parent
	
	# Declare initial state
	
	change_state(INITIAL_STATE)

func process_input(event: InputEvent):
	
	# Change state upon detecting input
	
	var new_state = current_state.process_input(event)
	
	# These functions usually return NULL, unless an event occurs which would trigger a state change
	# Same with all other current_state methods used here
	
	if new_state:
		change_state(new_state)

func process_physics(delta: float):
	
	# Change state upon detecting physics-dependent signal
	
	var new_state = current_state.process_physics(delta)
	
	if new_state:
		change_state(new_state)

func process(delta: float):
	
	# Change state upon detecting frame-dependent signal
	
	var new_state = current_state.process(delta)
	
	if new_state:
		change_state(new_state)

func change_state(new_state: State):
	# Exits current state
	
	if current_state:
		current_state.exit()
	
	# Updates current state to the new desired state and enters
	
	current_state = new_state
	
	if not $"..".is_in_group("minotarget"):
		print(current_state)
	
	current_state.enter()
