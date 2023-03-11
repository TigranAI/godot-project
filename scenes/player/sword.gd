extends Area2D

func _ready():
	pass # Replace with function body.

func _on_Sword_body_entered(body):
	if body.is_in_group("Enemies"):
		body.receive_damage(self, 2);
	pass# Replace with function body.
