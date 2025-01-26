class_name ScreenTransition
extends CanvasItem

@export var close_duration: float = 1
@export var open_duration: float = 0.5
@export var close_curve: Curve
@export var open_curve: Curve
@export var maximum_radius: float = 2.1

var tween: Tween


func _ready() -> void:
	set_radius(maximum_radius)


func close():
	set_radius(maximum_radius)
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_method(set_closing_radius, 0.0, 1.0, close_duration)

func open():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_method(set_opening_radius, 0.0, 1.0, open_duration)

func set_closing_radius(t: float):
	t = close_curve.sample(t)
	set_radius(lerpf(maximum_radius, 0, t))

func set_opening_radius(t: float):
	t = open_curve.sample(t)
	set_radius(lerpf(0, maximum_radius, t))

func set_radius(radius: float):
	material.set_shader_parameter('radius', radius)
