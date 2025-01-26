extends CharacterBody2D

signal dashed

@export var move_force: float = 8
@export var dash_force: float = 600
@export var gravity: float = 0.5
@export_range(0, 1) var friction: float = 0.1

@export_subgroup('bubbles', 'bubble')
@export var bubble_blower: BubbleBlower
@export var bubble_fixed_recoil: float = 10
@export var bubble_recoil_size_multiplier: float = 2

var direction = 1


func _ready() -> void:
	bubble_blower.bubble_blown.connect(_on_bubble_blown)

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity += move_force * input_direction.normalized()
	velocity.y += gravity

	if abs(input_direction.x) > 0.1:
		direction = 1 if (input_direction.x > 0) else -1

	if bubble_blower.can_dash && Input.is_action_just_pressed('dash'):
		bubble_blower.spawn_dash_bubble()
		velocity.x += direction * dash_force
		dashed.emit()
	
	velocity *= (1 - friction)
	move_and_slide()


func _on_bubble_blown(bubble_size):
	var recoil = bubble_fixed_recoil
	recoil += bubble_recoil_size_multiplier * bubble_size
	velocity.x -= direction * recoil
