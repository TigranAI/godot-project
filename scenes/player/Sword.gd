extends Area2D


func _on_Sword_body_entered(body):
	if body.is_in_group("Enemies"):
		body.receive_damage(self, 2);


func attack(direction):
	match direction:
		Vector2(0, 1):
			rotation_degrees = 180
		Vector2(1,0), Vector2(1,1), Vector2(1,-1):
			rotation_degrees= 90
		Vector2(-1,0), Vector2(-1,1), Vector2(-1,-1):
			rotation_degrees = -90
		Vector2(0, -1):
			rotation_degrees = 0
