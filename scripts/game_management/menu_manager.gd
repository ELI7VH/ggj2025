extends Control

@export var main_menu_root: Control
@export var level_manager: LevelProgressionManager


func start_game():
	main_menu_root.hide()
	level_manager.load_starting_level()

func show_level_select_screen():
	pass

func quit():
	get_tree().quit()


func toggle_pause():
	get_tree().paused = !get_tree().paused