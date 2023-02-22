extends Control

export (String, FILE, "*.tscn,*.scn") var levelScene = "res://levels/baseLevel.tscn"

signal gameStarted
signal gameResumed
signal optionsPressed

func _on_Start_pressed() -> void:
	emit_signal("gameStarted")

func _on_Options_pressed() -> void:
	emit_signal("optionsPressed")

func _on_Exit_pressed() -> void:
	get_tree().quit()

func _on_Resume_pressed():
	emit_signal("gameResumed")
