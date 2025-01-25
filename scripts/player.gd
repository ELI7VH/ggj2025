extends RigidBody2D

# call .emit when picking up a bubble
signal breath_filled
# call .emit when breath has been exhausted
signal breath_exhausted

@export var speed: float = 100
@export var bubbleScene: PackedScene
@export var spitspeed = 2000
var force = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	apply_central_force(speed * input_direction.normalized())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# TODO move this to base level node and put in a menu
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
	if Input.is_action_pressed("blow"):
		force = force + spitspeed * _delta
		print(force)
	if Input.is_action_just_released("blow"):
		var newBubble = bubbleScene.instantiate()
		newBubble.position.x = position.x - 25
		newBubble.position.y = position.y
		newBubble.floatup.x = -force
		get_parent().add_child(newBubble)
