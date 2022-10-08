extends Node2D

onready var target = $SimpleTarget
onready var nav = $Navigation2D

func get_path_to_target(from):
	return nav.get_simple_path(from, target.global_position, false)
