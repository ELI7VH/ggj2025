extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_bubble_blower_breath_exhausted() -> void:
	pitch_scale = randf() * 0.2 + 0.9
	play()


func _on_bubble_blower_bubble_cant_blow() -> void:
	pitch_scale = 0.6
	play()
