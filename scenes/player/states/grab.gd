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

func enter() -> void:
	super()
	print('grab')
	parent.velocity.y = 0
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	time_since_grabbed += delta
	
	if time_since_grabbed > grab_time:
		grab_fall.disallow_grab()
		return grab_fall
		
	if Input.is_action_just_pressed("jump"):
		return jump_wall
	
	parent.move_and_slide()
	
	return null
	
func exit() -> void:
	time_since_grabbed = 0
