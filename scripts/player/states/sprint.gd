extends State

@export
var idle: State
@export
var run: State
@export
var fall: State
@export
var jump: State
@export
var vault: State

@export
var sprint_boost = 200

func enter(delta_accumulated: float) -> void:
	print('sprint')
	super(delta_accumulated)
	var movement = Input.get_axis('left', 'right') * move_speed
	if movement > 0:
		parent.velocity.x = movement + sprint_boost
	else:
		parent.velocity.x = movement - sprint_boost
	parent.move_and_slide()

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
