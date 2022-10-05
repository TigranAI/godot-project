extends KinematicBody2D

export var speed = 100
export var threshold = 16
export var hp = 300
export var damage = 10

var path = []
var velocity = Vector2.ZERO

var current_hp = hp

func initialize(pos, pth) -> void:
	path = pth
	position = pos

func _physics_process(_delta: float) -> void:
	if path.size() > 0:
		move_to_target()

func move_to_target() -> void:
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * speed
		velocity = move_and_slide(velocity)

func receive_damage(from, value):
	hp -= value
	if hp <= 0:
		queue_free()

func on_player_in_range(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().call_group("Player", "receive_damage", self, damage)

func on_end_point_in_range(body: Node) -> void:
	if body.is_in_group("EndPoint"):
		queue_free()
