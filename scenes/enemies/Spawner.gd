extends Node2D

var enemyScene = load("res://scenes/enemies/simple_enemy/SimpleEnemy.tscn")
var path = []

func _ready() -> void:
	yield(owner, "ready")

func spawn_enemy() -> void:
	var enemy = enemyScene.instance()
	enemy.initialize(global_position, owner.get_path_to_target(global_position))
	owner.add_child(enemy)


