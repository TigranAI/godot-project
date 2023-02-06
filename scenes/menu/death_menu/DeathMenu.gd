extends Control

export (String, FILE, "*.tscn,*.scn") var menuScene = "res://scenes/menu/main_menu/MainMenu.tscn"

var is_paused = false setget set_is_paused

func _ready():
	var player = get_parent().get_parent()
	if (player != null):
		player.connect("playerDead", self, "show_death_screen")

func show_death_screen():
	self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Exit_pressed() -> void:
	self.is_paused = false
	get_tree().change_scene(menuScene)

func _on_Restart_pressed() -> void:
	self.is_paused = false
	get_tree().reload_current_scene()
