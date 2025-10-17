extends State

@export
var fall: State
@export
var jump_wall: State
@export
var vault: State
@export
var grab_fall: GrabFall

@export
var grab_time = 1

var time_since_grabbed: float = 0

func enter(delta_accumulated: float) -> void:
	super(delta_accumulated)
	#print('grab')
	parent.velocity.y = 0
	parent.velocity.x = 0
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return jump_wall
	
	var wall_normal = parent.get_wall_normal()
	if wall_normal and parent.is_on_wall():
		if wall_normal.x > 0 and Input.is_action_pressed("left"):
			return null
		else:
			return fall
		if wall_normal.x < 0 and Input.is_action_pressed("right"):
			return null
		else:
			return fall
			
	return null

func process_physics(delta: float) -> State:
	time_since_grabbed += delta
	
	if time_since_grabbed > grab_time:
		grab_fall.disallow_grab()
		return grab_fall
	
	parent.move_and_slide()
	
	return null
	
func exit() -> void:
	time_since_grabbed = 0
