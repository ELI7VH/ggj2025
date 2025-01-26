extends Node

signal level_started
signal level_completed


func notify_level_started(): level_started.emit()
func notify_level_completed(): level_completed.emit()