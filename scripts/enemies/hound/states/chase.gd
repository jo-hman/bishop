extends EnemyState

@export var idle: EnemyState
@export var lit: EnemyState
@export var lose_target_range: float = 600.0
@export var teleport_duration := 0.5
var teleport_timer := 0.0
var is_teleporting := false
var teleport_target_pos: Vector2


func enter(delta_accumulated: float) -> void:
	print("Chasing")
	super.enter(delta_accumulated)
	is_teleporting = false
	teleport_timer = 0.0
	if parent.target:
		navigation_agent.target_position = parent.target.global_position


func process_physics(delta: float) -> EnemyState:
	# Handle teleport delay first
	if is_teleporting:
		teleport_timer -= delta
		if teleport_timer <= 0.0:
			parent.global_position = teleport_target_pos
			is_teleporting = false
		else:
			# Freeze movement during teleport
			parent.velocity = Vector2.ZERO
			return null

	# Standard chase logic
	if not parent.target:
		return idle
	if is_hit_with_rays():
		return lit

	navigation_agent.target_position = parent.target.global_position

	var next_point = navigation_agent.get_next_path_position()
	var direction = (next_point - parent.global_position).normalized()
	parent.velocity.x = direction.x * move_speed
	parent.velocity.y += gravity * delta
	parent.move_and_slide()

	var distance = parent.global_position.distance_to(parent.target.global_position)
	if distance > lose_target_range:
		return idle

	return null


func on_link_reached(details: Dictionary) -> EnemyState:
	var link = details.get("owner")
	var link_exit_position = details.get("link_exit_position")

	if link and link is NavigationLink2D:
		if link.bidirectional or link.enabled:
			# Start teleport timer instead of instant move
			is_teleporting = true
			teleport_timer = teleport_duration
			teleport_target_pos = link_exit_position

	return null
