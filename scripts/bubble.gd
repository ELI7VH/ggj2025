class_name Bubble
extends RigidBody2D

const GROUP_NAME = 'bubbles'

@export var buoyancy: float = 200
@export var collision_shape: CollisionShape2D
@export var drawer: BubbleDrawer

var radius: float = 8: set = set_radius
var buoyancy_enabled: bool = false: set = set_physics_enabled

var collider: CircleShape2D


func _ready():
	add_to_group(GROUP_NAME)
	collider = CircleShape2D.new()
	collision_shape.shape = collider
	collider.radius = radius


func _physics_process(_delta: float) -> void:
	if buoyancy_enabled:
		apply_central_force(Vector2.UP * buoyancy)

func _process(_delta: float) -> void:
	# remove bubble if it goes off screen
	if (position.y < 0):
		position.y = 0


func set_radius(value: float):
	radius = value
	drawer.radius = value
	if collider:
		collider.radius = value

func set_physics_enabled(value: bool):
	buoyancy_enabled = value
	collision_layer = 1 if value else 0
