class_name BubbleBlower
extends Node2D

signal bubble_charging
signal bubble_blown(breath_expended: float)
signal breath_gained(breath_amount: float)
signal breath_exhausted

@export var bubble_scene: PackedScene
@export var base_spawn_offset: float = 10
@export var collection_proximity: float = 12
@export var breath_maximum: float = 40
@export var breath_empty_threshold: float = 2

@export_subgroup('size', 'size')
@export var size_minimum: float = 4
@export var size_maximum: float = 20
@export var size_growth_speed: float = 20

@export_subgroup('dash', 'dash')
@export var dash_spawn_offset: float = -20
@export var dash_spawn_impulse: Vector2 = Vector2(-200, 0)

@onready var breath: float = breath_maximum
var can_dash: bool: get = get_can_dash
var direction: int: get = get_direction
var spawn_point: Vector2: get = get_spawn_point

var held_bubble: Bubble = null
var fresh_bubbles: Array[Bubble] = []


func _process(delta: float) -> void:
	fresh_bubbles = fresh_bubbles.filter(bubble_is_close)
	var world_bubbles = get_tree().get_nodes_in_group(Bubble.GROUP_NAME)
	var collectable_bubbles = world_bubbles.filter(func(bubble): return !fresh_bubbles.has(bubble))
	for bubble in collectable_bubbles.filter(bubble_is_close):
		collect_bubble(bubble)


	if is_instance_valid(held_bubble):
		held_bubble.global_position = spawn_point
		
		if Input.is_action_just_released('blow'):
			held_bubble.buoyancy_enabled = true
			bubble_blown.emit(held_bubble.radius)
			expend_breath(held_bubble.radius)
			held_bubble = null
		else:
			var bubble_size = held_bubble.radius
			bubble_size += size_growth_speed * delta
			held_bubble.radius = limit_bubble_size(bubble_size)
	
	elif Input.is_action_just_pressed('blow') && breath > breath_empty_threshold:
		held_bubble = bubble_scene.instantiate()
		bubble_charging.emit()
		fresh_bubbles.append(held_bubble)
		held_bubble.buoyancy_enabled = false
		held_bubble.radius = size_minimum
		get_parent().add_sibling(held_bubble)
		held_bubble.global_position = spawn_point


func spawn_dash_bubble():
	var dash_bubble = bubble_scene.instantiate()
	fresh_bubbles.append(dash_bubble)
	dash_bubble.buoyancy_enabled = true
	dash_bubble.radius = size_minimum
	expend_breath(size_minimum)
	get_parent().add_sibling(dash_bubble)
	dash_bubble.global_position = global_position
	dash_bubble.global_position.x += direction * dash_spawn_offset
	var spawn_velocity = Vector2.RIGHT * direction * dash_spawn_impulse
	dash_bubble.apply_central_impulse(spawn_velocity)

func get_can_dash() -> bool:
	return breath > 0


func expend_breath(bubble_size: float):
	breath -= bubble_size
	clamp_breath()
	if breath < breath_empty_threshold:
		breath_exhausted.emit()


func collect_bubble(bubble: Bubble):
	if breath >= breath_maximum:
		return
	if breath_maximum - breath > bubble.radius / 2:
		bubble.queue_free()
	else:
		bubble.radius -= breath_maximum - breath
	breath += bubble.radius
	clamp_breath()
	breath_gained.emit(bubble.radius)


func clamp_breath():
	breath = clampf(breath, 0, breath_maximum)

func limit_bubble_size(bubble_size: float) -> float:
	var breath_limit = max(breath, size_minimum)
	var current_maximum = min(size_maximum, breath_limit)
	return clamp(bubble_size, size_minimum, current_maximum)


func bubble_is_close(bubble) -> bool:
	var bubble_position = bubble.global_position
	var distance = spawn_point.distance_to(bubble_position)
	return distance < collection_proximity + bubble.radius

func get_spawn_point() -> Vector2:
	var offset_distance = base_spawn_offset
	if is_instance_valid(held_bubble):
		offset_distance += held_bubble.radius
	var offset = Vector2.RIGHT * direction * offset_distance
	return global_position + offset

func get_direction() -> int:
	return get_parent().direction
