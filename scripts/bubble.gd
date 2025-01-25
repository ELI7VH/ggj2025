extends RigidBody2D

@export var floatup = Vector2(0,-200)
@export var sideDecel = 0.7
@export var timetolive = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	apply_central_force(floatup)	
	floatup.x = floatup.x * sideDecel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# remove bubble if it goes offscreen
	timetolive = timetolive - delta
	if (position.y < 0) or (timetolive < 0):
		queue_free()
	pass
