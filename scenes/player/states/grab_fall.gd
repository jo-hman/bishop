class_name GrabFall
extends State

@export
var fall: State
@export
var wall_jump: State
@export
var run: State
@export
var idle: State
@export
var grab: State

@export
var grab_friction = 0.2
@export
var max_grab_fall_speed = 100
@export
var time_to_grab = 1

var time_since_entered: float = 0
var grab_disallow = false

func enter() -> void:
	super()
	print('grab fall')

func process_physics(delta: float) -> State:
	time_since_entered += delta
	
	if Input.is_action_pressed('grab'):
		if parent.is_on_wall() or parent.is_on_ceiling():
			if time_since_entered > time_to_grab:
				return grab
	
	parent.velocity.y += gravity * delta * grab_friction
	parent.velocity.y = clamp(parent.velocity.y, 0, max_grab_fall_speed)
	
	var movement = Input.get_axis('left', 'right') * move_speed
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		return wall_jump
		
	var wall_normal = parent.get_wall_normal()
	if wall_normal and parent.is_on_wall():
		if wall_normal.x > 0 and not Input.is_action_pressed("left"):
			return fall
		if wall_normal.x < 0 and not Input.is_action_pressed("right"):
			return fall
	else:
		return fall
		
	if Input.is_action_just_pressed("grab") and not grab_disallow:
		if parent.is_on_wall() or parent.is_on_ceiling():
			return grab
	
	if parent.is_on_floor():
		if movement != 0:
			return run
		return idle
		
	return null

func exit() -> void:
	time_since_entered = 0
	grab_disallow = false
	
func disallow_grab():
	grab_disallow = true
