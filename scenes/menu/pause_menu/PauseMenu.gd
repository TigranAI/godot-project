extends Control

export (String, FILE, "*.tscn,*.scn") var menuScene = "res://scenes/menu/main_menu/MainMenu.tscn"

onready var options = $Options

var is_paused = false setget set_is_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	options.hide()
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Resume_pressed() -> void:
	self.is_paused = false

func _on_Settings_pressed() -> void:
	options.show()

func _on_Exit_pressed() -> void:
	self.is_paused = false
	get_tree().change_scene(menuScene)


func _on_Restart_pressed() -> void:
	self.is_paused = false
	get_tree().reload_current_scene()
