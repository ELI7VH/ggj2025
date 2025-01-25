extends Node2D

@export var side_jitter = 2
@export var emit_frequency = 0.2

var bubbleScene = preload("res://scenes/branches/bubble.tscn")
var count = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if count > emit_frequency:
		print(delta)
		var newBubble = bubbleScene.instantiate()
		newBubble.position = position
		newBubble.position.x = position.x + randi_range(-side_jitter,side_jitter)
		get_parent().add_child(newBubble)
		count = 0.0
	else:
		count = count + delta
