extends State

@export
var fall: State
@export
var run: State
@export
var jump: State
@export
var sprint: State
#@export
#var slide: State


@export
#effectivelly 0.1 seconds window to do sprint
var sprint_timer: float = 0.2

var left_sprint: bool = false
var right_sprint: bool = false

func enter(delta_accumulated: float) -> void:
	#print('idle')
	super(delta_accumulated)
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		left_sprint = false
		right_sprint = false
		return fall
	
	if Input.is_action_pressed('left') and Input.is_action_pressed('right'):
		return null
	if Input.is_action_pressed('left'):
		left_sprint = true
		if delta_accumulated < sprint_timer and left_sprint:
			left_sprint = false
			right_sprint = false
			return sprint
		return run
	if Input.is_action_pressed('right'):
		right_sprint = true
		if delta_accumulated < sprint_timer and right_sprint:
			left_sprint = false
			left_sprint = false
			return sprint
		return run
	
	return null
