class_name BubbleReceptacle
extends Node2D

signal bubble_added(current_progress: float)
signal threshold_reached

@export var threshold_offset: float = 6
@export var required_lift_force: float = 600

@export var claw: RigidBody2D
@export var fill_area: Area2D
@export var screw: Sprite2D
@export var animator: AnimationPlayer

@onready var rest_height: float = claw.position.y
@onready var height_threshold: float = rest_height - threshold_offset
@onready var screw_rest_height: float = screw.region_rect.size.y

var listening_for_threshold = true

func _ready() -> void:
	claw.constant_force = Vector2.DOWN * required_lift_force


func _physics_process(_delta: float) -> void:
	var screw_rect = Rect2(screw.region_rect)
	var y_offset = claw.position.y - rest_height
	screw_rect.position.y = -y_offset
	screw_rect.size.y = screw_rest_height + y_offset * 2
	screw.region_rect = screw_rect

	if claw.position.y < height_threshold && listening_for_threshold:
		listening_for_threshold = false
		animator.play('spin')
		threshold_reached.emit();
		LevelSignalBus.notify_level_completed()


func _on_body_entered_fill_area(body: PhysicsBody2D):
	if body is Bubble && listening_for_threshold:
		bubble_added.emit(get_normalized_progress())


func get_normalized_progress() -> float:
	return remap(claw.position.y, rest_height, height_threshold, 0, 1)


func _on_threshold_reached() -> void:
	pass # Replace with function body.
