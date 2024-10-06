extends State

@export
var fall: State
@export
var run: State
@export
var jump: State
#@export
#var slide: State

func enter() -> void:
	print('idle')
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump
	if Input.is_action_pressed('left') or Input.is_action_pressed('right'):
		return run
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall
	return null
