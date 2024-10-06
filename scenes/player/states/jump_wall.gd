extends InAirState

@export
var idle: State
@export
var run: State
@export
var vault: State
@export
var grab: State
@export 
var fall: InAirState
@export 
var grab_fall: State

@export
var jump_force: float = 300.0

func _ready() -> void:
	fall.disallow_buffered_jump()

func enter() -> void:
	super()
	var wall_normal = parent.get_wall_normal()
	if wall_normal:
		print(wall_normal)
		parent.velocity.x = wall_normal.x * move_speed
	parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall
	
	var movement = Input.get_axis('left', 'right') * move_speed
	
	handle_horizontal_velocity(movement, delta)
	
	parent.move_and_slide()
	
	
	if parent.is_on_floor():
		if movement != 0:
			return run
		return idle
		
	if Input.is_action_just_pressed("grab"):
		if parent.is_on_wall() or parent.is_on_ceiling():
			return grab
	
	return null
