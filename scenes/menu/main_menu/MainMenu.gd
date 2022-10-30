extends Control

export (String, FILE, "*.tscn,*.scn") var levelScene = "res://scenes/enemies/EnemyTestScene.tscn"

onready var options = $Options

func _on_Start_pressed() -> void:
	get_tree().change_scene(levelScene)

func _on_Options_pressed() -> void:
	options.show()

func _on_Exit_pressed() -> void:
	get_tree().quit()
