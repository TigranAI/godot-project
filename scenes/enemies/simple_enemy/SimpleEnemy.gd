extends KinematicBody2D

export var speed = 100
export var threshold = 16

var path = []
var nav = null
var velocity = Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")
	nav = owner.nav
	
func _physics_process(_delta: float) -> void:
	if path.size() > 0:
		move_to_target()
		
func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * speed
		velocity = move_and_slide(velocity)
		
func get_target_path(target_pos):
	path = nav.get_simple_path(global_position, target_pos, false)
