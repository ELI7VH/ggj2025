extends Control

@export var level_manager: LevelProgressionManager
@export var volume_sliders: Array[Slider]

@export_subgroup('submenus')
@export var start_menu_root: Control
@export var level_select_root: Control
@export var pause_menu_root: Control

@export_subgroup('focus elements', 'focus_entry')
@export var focus_entry_start: Control
@export var focus_entry_pause: Control

var in_level: bool = false


func _ready() -> void:
	LevelSignalBus.level_started.connect(_on_level_started)

	var master_bus_index = AudioServer.get_bus_index('Master')
	var linear_volume = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	for slider in volume_sliders:
		slider.value = linear_volume
		slider.value_changed.connect(_set_master_volume)
	show_start_menu()


func _process(_delta: float):
	if in_level && Input.is_action_just_pressed('menu'):
		toggle_pause()


func start_game():
	$StartMenuBGM.stop()
	start_menu_root.hide()
	level_manager.load_starting_level()
	get_tree().paused = false
	in_level = true

func restart_level():
	level_manager.reset_level()


func show_start_menu():
	$PauseMenuBGM.stop()
	$StartMenuBGM.play()
	level_manager.unload_level()
	in_level = false
	hide_all_submenus()
	start_menu_root.show()
	focus_entry_start.grab_focus()

func show_level_select_screen():
	hide_all_submenus()
	level_select_root.show()

func quit():
	get_tree().quit()


func toggle_pause():
	hide_all_submenus()
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		$PauseMenuBGM.play()
		pause_menu_root.show()
		focus_entry_pause.grab_focus()
	else:
		$PauseMenuBGM.stop()


func hide_all_submenus():
	start_menu_root.hide()
	level_select_root.hide()
	pause_menu_root.hide()


func _on_level_started():
	in_level = true
	get_tree().paused = false
	hide_all_submenus()


func _set_master_volume(value: float):
	var master_bus_index = AudioServer.get_bus_index('Master')
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))