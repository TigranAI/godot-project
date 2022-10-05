extends Node2D

onready var target = $SimpleTarget
onready var nav = $Navigation2D


func _on_Timer_timeout():
	get_tree().call_group("TestEnemyGroup", 'get_target_path', target.global_position)
