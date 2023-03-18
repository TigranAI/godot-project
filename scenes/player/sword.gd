extends Area2D

var velocity = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _on_Sword_body_entered(body):
	if body.is_in_group("Enemies"):
		body.receive_damage(self, 2);
	pass# Replace with function body.

#func _physics_process(delta):
#	#position = position + velocity * delta * 40
#	$Sprite.position = $CollisionShape2D.position
#
func attack( direction):
	match direction:
		"down":
			rotation_degrees = 180

		"right":
			rotation_degrees= 90

		"left":
			rotation_degrees = -90

		"up":
			rotation_degrees = 0
#
#
#	#velocity.x += 1
#
#func attack_end():
#	velocity = Vector2.ZERO
