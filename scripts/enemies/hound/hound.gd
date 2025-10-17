class_name Enemy
extends CharacterBody2D

@export
var target: Player
@onready
var animations = $AnimatedSprite2D
@onready
var state_machine = $StateMachine
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	state_machine.init(self, navigation_agent, target)
	navigation_agent.link_reached.connect(_on_link_reached)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
	# Check each ray from the player
	

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_link_reached(details: Dictionary) -> void:
	state_machine.on_link_reached(details)
