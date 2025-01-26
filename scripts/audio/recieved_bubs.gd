extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_receptacle_bubble_added(current_progress: float) -> void:
	var i = floori(current_progress * 6);
	
	print("progress: ",current_progress, "::", i)
	if i == 6:
		return
	
	play()
