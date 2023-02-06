extends KinematicBody2D

var hp = 10;
var bounce_velocity 
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
		bounce_velocity =  -0.2 * global_position.direction_to(body.global_position);
		#print (bounce_velocity);
		body.take_damage(2,bounce_velocity);
