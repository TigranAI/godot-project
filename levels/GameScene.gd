extends Control

export(String, FILE, ".tscn") var baseScene = "res://levels/baseLevel.tscn"
export(String, FILE, ".tscn") var playerScene = "res://scenes/player/player.tscn"

signal onLevelResumed

var playerNodeName = "CurrentPlayer"
var levelNodeName= "CurrentLevel"

var currentScene: String = baseScene
var player: Object = null
var level: Object = null

func load_level_scene(scenePath: String):
	if has_node(playerNodeName): return
	
	currentScene = scenePath
	var level_res = load(scenePath)
	level = level_res.instance()
	level.set_name(levelNodeName)
	add_child(level)

func load_player():
	if has_node(playerNodeName): return
		
	var player_res = load(playerScene)
	player = player_res.instance()
	player.set_name(playerNodeName)
	add_child(player)

func unload_player():
	player.queue_free()

func unload_level():
	level.queue_free()

func _on_restart():
	unload_player()
	unload_level()
	load_level_scene(currentScene)
	load_player()

func _on_game_started():
	visible = true
	load_level_scene(baseScene)
	load_player()

func _on_game_exit():
	visible = false
	player.queue_free()
	level.queue_free()

func _on_game_resume():
	visible = true
	load_level_scene(currentScene)
	load_player()
	emit_signal("onLevelResumed")
