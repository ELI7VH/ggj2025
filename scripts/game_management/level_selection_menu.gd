class_name LevelSelectionMenu
extends Control

@export var selection_button_scene: PackedScene
@export var selection_button_parent: GridContainer

@export var level_manager: LevelProgressionManager

var selection_buttons: Array[Button]


func _ready() -> void:
	visibility_changed.connect(_visibility_changed)

	selection_buttons = []
	var index = 0
	for level_scene in level_manager.levels:
		var new_button = selection_button_scene.instantiate()
		selection_button_parent.add_child(new_button)
		var on_press = func():
			level_manager.load_level(index)
			LevelSignalBus.notify_level_started()
		new_button.pressed.connect(on_press)
		index += 1
		new_button.text = str(index)
		selection_buttons.append(new_button)


func _visibility_changed():
	if visible && selection_buttons:
		selection_buttons[0].grab_focus()
