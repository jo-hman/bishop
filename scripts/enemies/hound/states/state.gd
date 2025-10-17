class_name EnemyState
extends Node

@export
var animation_name: String
@export
var move_speed: float = 200

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var delta_accumulated: float


var parent: Enemy
var navigation_agent: NavigationAgent2D
var target: Player

func enter(delta_accumulated: float) -> void:
	parent.animations.play(animation_name)
	self.delta_accumulated = delta_accumulated

func exit() -> void:
	pass

func process_input(event: InputEvent) -> EnemyState:
	return null

func process_frame(delta: float) -> EnemyState:
	return null

func process_physics(delta: float) -> EnemyState:
	return null
	
func on_link_reached(details: Dictionary) -> EnemyState:
	return null
	
func is_hit_with_rays() -> bool:
	for ray in [target.light_cast1, target.light_cast2, target.light_cast3]:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider is Enemy:
				return true
	return false
