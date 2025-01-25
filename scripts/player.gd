extends RigidBody2D

var bubbleScene = preload("res://scenes/branches/bubble.tscn")

var direction = Vector2(0,0)
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = input_direction * speed
	apply_central_force(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var newBubble = bubbleScene.instantiate()
		newBubble.position.x = position.x - 25
		newBubble.position.y = position.y
		get_parent().add_child(newBubble)
