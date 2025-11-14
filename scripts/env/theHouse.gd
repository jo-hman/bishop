# TheHouse.gd
class_name TheHouse
extends InteractableArea

@export var player: Player
@onready var the_house_canvas: TheHouseCanvas = $TheHouseCanvas

func ready() -> void:
	the_house_canvas.hide()

func interact() -> void:
	player.disableMovement()
	the_house_canvas.fade_in()

func _unhandled_input(event: InputEvent) -> void:
	if the_house_canvas.is_visible() and event.is_action_pressed("esc"):
		the_house_canvas.fade_out(func ():
			player.enableMovement()
		)
