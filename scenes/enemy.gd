extends KinematicBody2D

var hp = 10;

func _ready():
	pass # Replace with function body.


func take_damage(damage):
	if damage >= hp:
		self.hide();
		$CollisionShape2D.set_deferred("disabled", true);
	else:
		hp-=damage;


func _on_DamageArea_body_entered(body:Node2D):
	if body.has_method("take_damage"):
		body.take_damage(2);
