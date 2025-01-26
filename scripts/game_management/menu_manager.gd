extends Control

@export var start_menu_root: Control
@export var level_manager: LevelProgressionManager
@export var volume_slider: Slider


func _ready() -> void:
	var master_bus_index = AudioServer.get_bus_index('Master')
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	volume_slider.value_changed.connect(_set_master_volume)


func start_game():
	start_menu_root.hide()
	level_manager.load_starting_level()

func show_start_menu():
	start_menu_root.show()

func show_level_select_screen():
	start_menu_root.hide()

func quit():
	get_tree().quit()


func toggle_pause():
	get_tree().paused = !get_tree().paused


func _set_master_volume(value: float):
	var master_bus_index = AudioServer.get_bus_index('Master')
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
