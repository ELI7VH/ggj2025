class_name ScreenTransition
extends CanvasItem

@export var close_duration: float = 1
@export var open_duration: float = 0.5
@export var close_curve: Curve
@export var fill_duration: float = 0.3
@export var maximum_radius: float = 2.1

var tween: Tween


func _ready() -> void:
	set_radius(maximum_radius)
	set_outer_radius(maximum_radius)


func close():
	set_radius(maximum_radius)
	set_outer_radius(maximum_radius)
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_method(set_closing_radius, 0.0, 1.0, close_duration)

func open():
	set_radius(0)
	set_outer_radius(maximum_radius)
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_method(set_radius, 0.0, maximum_radius, open_duration)


func fill_then_open():
	set_radius(0)
	set_outer_radius(0)
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_method(set_outer_radius, 0.0, maximum_radius, fill_duration)
	tween.tween_interval(fill_duration)
	tween.tween_method(set_radius, 0.0, maximum_radius, open_duration)


func set_closing_radius(t: float):
	t = close_curve.sample(t)
	set_radius(lerpf(maximum_radius, 0, t))


func set_radius(radius: float):
	material.set_shader_parameter('radius', radius)

func set_outer_radius(radius: float):
	material.set_shader_parameter('outer_radius', radius)