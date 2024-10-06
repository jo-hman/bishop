extends InAirState

@export
var idle: State
@export
var run: State
@export
var vault: State
@export
var roll: State
@export
var jump: State
@export
var grab: State
@export 
var grab_fall: State

@export
var max_falling_speed = 400
@export
var buffered_jump_timing: float = 0.1

var time_since_falling: float = 0
var time_to_grounded: float = -1

func exit() -> void:
	time_since_falling = 0
	time_to_grounded = 0
	
func enter() -> void:
	print('fall')
	super()

func process_physics(delta: float) -> State:
	
	time_since_falling += delta
	if time_to_grounded > 0:
		time_to_grounded += delta
	
	parent.velocity.y += gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, 0, max_falling_speed)
#	TODO dodaj max predkosc spadania i zwieksz gravity zeby bylo mnie floaty
	
	var movement = Input.get_axis('left', 'right') * move_speed

	handle_horizontal_velocity(movement, delta)
	
	parent.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		print(buffered_jump)
		if buffered_jump and buffered_jump_timing > time_since_falling:
			return jump
		time_to_grounded = delta
		
	
	if parent.is_on_floor():
		if time_to_grounded > 0 && time_to_grounded < buffered_jump_timing:
			return jump
		if movement != 0:
			return run
		return idle
	
	if Input.is_action_just_pressed("grab"):
		print('grab')
		if parent.is_on_wall() or parent.is_on_ceiling():
			print('grabbed')
			return grab
	
	var wall_normal = parent.get_wall_normal()
	if wall_normal and parent.is_on_wall():
		if wall_normal.x > 0 and Input.is_action_pressed("left"):
			return grab_fall
		if wall_normal.x < 0 and Input.is_action_pressed("right"):
			return grab_fall
	
	return null
