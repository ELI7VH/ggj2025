extends Node

signal level_started
signal level_completed
signal reset_triggered


func notify_level_started(): level_started.emit()
func notify_level_completed(): level_completed.emit()
func notify_reset_triggered(): reset_triggered.emit()