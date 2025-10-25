class_name ReactLight
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D

var is_lit: bool = false
var fade_time := 4.0       # seconds to fade out
var appear_time := 0.2     # seconds to fade in
var tween: Tween

# --- Randomization settings ---
@export var randomize_light := true         # toggle this to enable/disable randomness
var base_energy := 1.0              # default light energy
var energy_variation := 0.3         # ± range around base_energy
var base_scale := Vector2(1.0, 1.0) # default scale
var scale_variation := 0.3          # ± range (e.g. 0.3 = ±30%)

func _ready() -> void:
	point_light_2d.visible = false
	point_light_2d.energy = 0.0

func on_light_hit() -> void:
	if is_lit:
		return
	is_lit = true

	if tween and tween.is_running():
		tween.kill()

	# --- Apply randomization if enabled ---
	var target_energy = base_energy
	var target_scale = base_scale
	if randomize_light:
		target_energy = base_energy + randf_range(-energy_variation, energy_variation)
		target_energy = clamp(target_energy, 0.1, 2.0)  # avoid 0 or extreme values
		var scale_factor = 1.0 + randf_range(-scale_variation, scale_variation)
		target_scale = base_scale * scale_factor

	point_light_2d.visible = true
	point_light_2d.scale = target_scale

	# --- Tween fade-in ---
	point_light_2d.energy = 0.0
	tween = create_tween()
	tween.tween_property(point_light_2d, "energy", target_energy, appear_time)

func on_light_lost() -> void:
	if not is_lit:
		return
	is_lit = false

	if tween and tween.is_running():
		tween.kill()

	# --- Tween fade-out ---
	tween = create_tween()
	tween.tween_property(point_light_2d, "energy", 0.0, fade_time)
	tween.tween_callback(Callable(self, "_on_fade_out_done"))

func _on_fade_out_done() -> void:
	if not is_lit:
		point_light_2d.visible = false
