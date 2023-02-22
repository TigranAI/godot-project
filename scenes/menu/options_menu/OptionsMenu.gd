extends Control

export(String, FILE, ".cfg") var saveFilePath = "res://settings.cfg"

var _config_file = ConfigFile.new()
var _settings = {}
onready var _sections = {
	"video": $Panel/VBoxContainer/TabContainer/Video/VideoSection
}

func _ready() -> void:
	load_settings()

func save_settings() -> void:
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
	
	_config_file.save(saveFilePath)

func load_settings() -> void:
	var code = _config_file.load(saveFilePath)
	if code != OK:
		_settings = get_default_settings()
	else:
		for section in _config_file.get_sections():
			for key in _config_file.get_section_keys(section):
				set_value(section, key, _config_file.get_value(section, key))
			
			if _sections[section] != null:
				_sections[section].init_settings(_settings[section])

func get_default_settings():
	return {
		"video": {
			"resolution": "640x480",
			"fullscreen" : false
		}
	}

func set_value(section: String, key: String, value):
	if !_settings.has(section):
		_settings[section] = {}
	_settings[section][key] = value

func _on_Button_pressed() -> void:
	save_settings()
	hide()

func _on_video_value_updated(key: String, value) -> void:
	set_value("video", key, value)

func _on_show_settings():
	visible = true
