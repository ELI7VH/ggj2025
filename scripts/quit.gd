extends Node

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()