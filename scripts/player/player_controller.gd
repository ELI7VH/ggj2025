extends CharacterBody2D

signal dashed
signal turned

@export var move_force: float = 8
@export var dash_force: float = 600
@export var gravity: float = 0.5
@export_range(0, 1) var friction: float = 0.1
@export var dash_push_period: float = 0.2
@export var dash_push_force: float = 200

@export_subgroup('breath')
@export var initial_breath: float = 40
@export var breath_capacity: float = 40

@export_subgroup('bubbles', 'bubble')
@export var bubble_blower: BubbleBlower
@export var bubble_fixed_recoil: float = 10
@export var bubble_recoil_size_multiplier: float = 2

var direction = 1
var push_period_timer = 0


func _ready() -> void:
	bubble_blower.bubble_blown.connect(_on_bubble_blown)
	bubble_blower.breath_capacity = breath_capacity
	bubble_blower.breath = initial_breath

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity += move_force * input_direction.normalized()
	velocity.y += gravity

	if abs(input_direction.x) > 0.1:
		if direction * input_direction.x < 0:
			direction = 1 if (input_direction.x > 0) else -1
			turned.emit()

	if bubble_blower.can_dash && Input.is_action_just_pressed('dash'):
		bubble_blower.spawn_dash_bubble()
		velocity.x += direction * dash_force
		push_period_timer = dash_push_period
		dashed.emit()
	
	velocity *= (1 - friction)
	move_and_slide()
	
	if push_period_timer > 0:
		push_period_timer -= delta
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var colliding_body = collision.get_collider()
			if colliding_body is RigidBody2D:
				colliding_body.apply_central_force(-collision.get_normal() * dash_push_force)



func _on_bubble_blown(bubble_size):
	var recoil = bubble_fixed_recoil
	recoil += bubble_recoil_size_multiplier * bubble_size
	velocity.x -= direction * recoil

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
