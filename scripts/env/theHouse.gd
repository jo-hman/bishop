# TheHouse.gd
class_name TheHouse
extends InteractableArea

@export var player: Player
@onready var the_house_canvas: TheHouseCanvas = $TheHouseCanvas

func interact() -> void:
	player.disableMovement()
	the_house_canvas.fade_in()

func _unhandled_input(event: InputEvent) -> void:
	print('dupa ', the_house_canvas.is_visible())
	if the_house_canvas.is_visible() and event.is_action_pressed("esc"):
		the_house_canvas.fade_out(func ():
			player.enableMovement()
		)
