@tool
class_name Bubble
extends RigidBody2D

const GROUP_NAME = 'bubbles'

@export var radius: float = 8: set = set_radius

@export var base_buoyancy: float = 200
@export var buoyancy_reference_scale: float = 10
@export var collision_shape: CollisionShape2D
@export var drawer: BubbleDrawer

var physics_disabled: bool = false: set = set_physics_disabled

var collider: CircleShape2D


func _ready():
	add_to_group(GROUP_NAME)
	collider = CircleShape2D.new()
	collision_shape.shape = collider
	collider.radius = radius


func _physics_process(_delta: float) -> void:
	if !physics_disabled:
		var buoyancy_scale = radius / buoyancy_reference_scale
		var buoyancy = base_buoyancy * buoyancy_scale
		apply_central_force(Vector2.UP * buoyancy)


func set_radius(value: float):
	radius = value
	drawer.radius = value
	if collider:
		collider.radius = value

func set_physics_disabled(value: bool):
	physics_disabled = value
	freeze = value
	collision_shape.disabled = value
