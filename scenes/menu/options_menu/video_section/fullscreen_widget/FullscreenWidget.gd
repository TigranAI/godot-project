extends HBoxContainer

signal fullscreen_changed(fullscreen)

func set_value(fullscreen: bool) -> void:
	$CheckBox.pressed = fullscreen

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("fullscreen_changed", button_pressed)
