class_name MinoIdle extends State

# other possible states from here
@export var SearchState: State
@export var PursueState: State
@export var FollowState: State

@onready var idle_timer: Timer = $"../IdleTimer"

func enter():
	# set velocity to 0
	parent.velocity = Vector2(0, 0)
	# start idle timer for a second
	idle_timer.start(1)

func exit():
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta) -> State:
	# once timer is over, as long as player input isn't paused (game over / exit)
	if idle_timer.timeout and not Flags.input_paused:
		# enter search state
		return SearchState
	
	# no need to transfer to pursue / follow states from here, it's handled in the minotaur script itself
	
	return null

func process(_delta) -> State:
	return null
