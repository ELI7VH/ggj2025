extends AudioStreamPlayer

@export var bubble_blower: BubbleBlower

var t = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not playing:
		return
	
	var breath_expended = bubble_blower.held_bubble_scale

	var pitch = 1.0 + breath_expended * 0.5
	t += delta
	var mod = sin(t * TAU * 4) * 0.05
	pitch_scale = pitch + mod

func _on_bubble_blower_bubble_charging() -> void:
	play()

func stop_breath() -> void:
	stop()
	t = 0

func _on_bubble_blower_bubble_blown(_breath_expended: float) -> void:
	stop_breath()

func _on_bubble_blower_breath_exhausted() -> void:
	stop_breath()
