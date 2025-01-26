class_name LevelProgressionManager
extends Node

signal final_level_completed

@export var levels: Array[PackedScene]
@export var level_parent: Node

@export_subgroup('timing')
@export var load_delay: float = 1.5

@export_subgroup('editor_overrides')
@export var level_index_override: int = 0

var active_level_instance: Node
var current_level_index: int = 0

var load_delay_tween: Tween


func _ready():
	LevelSignalBus.level_completed.connect(_on_level_completed)
	LevelSignalBus.reset_triggered.connect(reset_level)


func reset_level():
	LevelSignalBus.notify_reset_triggered()
	unload_level()
	load_level(current_level_index)
	LevelSignalBus.notify_level_started()


func load_starting_level():
	load_level(level_index_override if OS.has_feature("editor") else 0)
	LevelSignalBus.notify_level_started()


func load_level(level_index: int):
	if level_index >= levels.size():
		final_level_completed.emit()
	else:
		active_level_instance = levels[level_index].instantiate()
		level_parent.add_child(active_level_instance)
		current_level_index = level_index

func unload_level():
	if is_instance_valid(active_level_instance):
		active_level_instance.queue_free()


func _on_level_completed():
	load_delay_tween = create_tween()
	load_delay_tween.tween_interval(load_delay)
	load_delay_tween.tween_callback(unload_level)
	load_delay_tween.tween_callback(_load_next_level)
	load_delay_tween.tween_callback(_end_loading)


func _load_next_level():
	unload_level()
	load_level(current_level_index + 1)
	get_tree().paused = true

func _end_loading():
	LevelSignalBus.notify_level_started()
	get_tree().paused = false