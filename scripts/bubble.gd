extends RigidBody2D

var floatup = Vector2(0,-200)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	apply_central_force(floatup)	
#	move_and_collide(floatup)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
