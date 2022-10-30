extends VBoxContainer

signal value_updated(key, value)

var _settings = {}

func init_settings(settings: Dictionary):
	_settings = settings
	for key in _settings:
		update_widget(key, _settings[key])

func set_value(key: String, value) -> void:
	emit_signal("value_updated", key, value)

func update_widget(key: String, value) -> void:
	match key:
		"resolution":
			$ResolutionWidget.set_value(value)
			set_resolution(value)
		"fullscreen":
			$FullscreenWidget.set_value(value)
			set_fullscreen(value)

func set_resolution(res: String) -> void:
	var values = res.split_floats("x")
	var resolution = Vector2(values[0], values[1])
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, resolution)
	OS.set_window_size(resolution)

func set_fullscreen(fullscreen: bool) -> void:
	OS.window_fullscreen = fullscreen
	set_resolution(_settings["resolution"])



func _on_resolution_changed(res: String) -> void:
	set_resolution(res)
	set_value("resolution", res)

func _on_FullscreenWidget_fullscreen_changed(fullscreen: bool) -> void:
	set_fullscreen(fullscreen)
	set_value("fullscreen", fullscreen)
