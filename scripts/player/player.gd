class_name Player
extends CharacterBody2D

@onready
var animations = $AnimatedSprite2D
@onready
var state_machine = $StateMachine

@onready var light: PointLight2D = $PointLight2D
@onready var light_cast1: RayCast2D = $RayCast2D
@onready var light_cast2: RayCast2D = $RayCast2D2
@onready var light_cast3: RayCast2D = $RayCast2D3

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	queue_redraw()
	update_light_rotation(light, delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)


var time_since_last_update = 0.0
var last_mouse_position = Vector2.ZERO
const MAX_LIGHT_UPDATES_PER_SECOND = 60
const LIGHT_UPDATE_INTERVAL = 1.0 / MAX_LIGHT_UPDATES_PER_SECOND
const MOUSE_MOVE_THRESHOLD = 0.2  # Minimum movement to trigger light updatex

# Update light and raycasts based on mouse movement
func update_light_rotation(light: PointLight2D, delta: float) -> void:
	time_since_last_update += delta
	if time_since_last_update >= LIGHT_UPDATE_INTERVAL:
		var current_mouse_position = get_global_mouse_position()
		if current_mouse_position.distance_to(last_mouse_position) > MOUSE_MOVE_THRESHOLD:
			# Calculate direction and angle
			var direction = current_mouse_position - light.global_position
			var angle = direction.angle()

			# Rotate the light and both raycasts
			light.rotation = angle
			# Base direction to mouse
			# Set rays with different offsets
			light_cast1.rotation = angle + deg_to_rad(-10)  # 10° left
			light_cast2.rotation = angle + deg_to_rad(10)   # 10° right
			light_cast3.rotation = angle   # 10° right

			## Optional: adjust raycast lengths if you want them to reach the mouse
			#var distance = direction.length()
			#light_cast1.target_position = Vector2(distance, 0)
			#light_cast2.target_position = Vector2(distance, 0)

			last_mouse_position = current_mouse_position
		time_since_last_update = 0.0



func _draw() -> void:
	_draw_ray(light_cast1, Color(1, 0, 0)) # red
	_draw_ray(light_cast2, Color(0, 1, 0)) # green
	_draw_ray(light_cast3, Color(0, 0, 1)) # blue


func _draw_ray(ray: RayCast2D, color: Color) -> void:
	if not is_instance_valid(ray):
		return

	# Ray origin in global space
	var start_global = ray.global_position

	# Compute ray end using rotation + target_position
	# target_position is local, so we rotate it by the ray's rotation in global space
	var end_global = start_global + ray.target_position.rotated(ray.global_rotation)

	# Convert to local coordinates for drawing
	var start_local = to_local(start_global)
	var end_local = to_local(end_global)

	# Draw the line
	draw_line(start_local, end_local, color, 2.0)

	# Draw collision point if it hits
	if ray.is_colliding():
		var hit_local = to_local(ray.get_collision_point())
		draw_circle(hit_local, 4.0, Color(1,1,0))
