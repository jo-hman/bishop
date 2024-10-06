extends State

@export
var sprint: State
@export
var idle: State
@export
var jump: State
@export
var vault: State
@export
var fall: InAirState
#@export
#var slide: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('left', 'right') * move_speed
	
	if movement == 0:
		return idle
	
	parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall
	return null
