@tool
class_name BubbleDrawer
extends Node2D

const SHINE_ARC_SEGMENTS := 6

@export var redraw: bool: set = set_redraw
@export var fill_colour := Color(0.9, 0.9, 1, 0.25)
@export var stroke_colour := Color(0.8, 0.85, 1.0, 0.7)
@export var radius: float = 20: set = set_radius
@export var stroke_width: float = 2.5

@export_subgroup("shine_arc", "shine_arc")
@export var shine_arc_colour := Color(1, 1, 1, 0.6)
@export_range(0, 1) var shine_arc_outer_radius_ratio: float = 0.8
@export_range(0, 1) var shine_arc_inner_radius_ratio: float = 0.6
@export_range(-PI, PI) var shine_arc_start_angle: float = -PI / 2
@export_range(-PI, PI) var shine_arc_end_angle: float = 0


func set_redraw(_value: bool):
	queue_redraw()

func set_radius(value: float):
	radius = value
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius - stroke_width / 2, fill_colour)
	draw_circle(Vector2.ZERO, radius, stroke_colour, false, stroke_width)
	draw_shine_arc()


func draw_shine_arc():
	var outer_radius = radius * shine_arc_outer_radius_ratio
	var inner_radius = radius * shine_arc_inner_radius_ratio
	
	var points = generate_crescent(outer_radius, inner_radius,
			shine_arc_start_angle, shine_arc_end_angle)
	draw_colored_polygon(points, shine_arc_colour)

func generate_crescent(outer_radius: float, inner_radius: float,
		angle_from: float, angle_to: float, segments := SHINE_ARC_SEGMENTS) -> PackedVector2Array:
	var points = PackedVector2Array()

	for i in range(segments + 1):
		var angle = lerp(angle_from, angle_to, float(i) / segments)
		points.push_back(Vector2.from_angle(angle) * outer_radius)
	
	for i in range(segments + 1):
		var angle = lerp(angle_to, angle_from, float(i) / segments)
		points.push_back(Vector2.from_angle(angle) * inner_radius)

	return points