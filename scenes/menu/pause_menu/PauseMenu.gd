extends Control

export (String, FILE, "*.tscn,*.scn") var menuScene = "res://scenes/menu/main_menu/MainMenu.tscn"

signal gameExit
signal showSettings
signal resume
signal pause
signal restart

var is_paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_paused(!is_paused)

func set_paused(value: bool):
	is_paused = value
	get_tree().paused = is_paused
	
	if value: emit_signal("pause")
	else: emit_signal("resume")
	
	visible = value

func _on_Resume_pressed() -> void:
	set_paused(false)

func _on_Settings_pressed() -> void:
	emit_signal("showSettings")

func _on_Exit_pressed() -> void:
	set_paused(false)
	emit_signal("gameExit")

func _on_Restart_pressed() -> void:
	set_paused(false)
	emit_signal("restart")

