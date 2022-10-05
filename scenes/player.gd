extends KinematicBody2D

export (int) var speed = 200
export (int) var attack_speed = 200
onready var _animated_sprite = $AnimatedSprite
onready var _weapon_area = $Weapon
onready var _weapon_collision = $Weapon/CollisionShape2D
var velocity = Vector2()
var last_direction = "down";
var attack = false;
var start_attack_angle=0;
var hp = 10;
var is_dead = false



func _ready():
	_weapon_area.hide();

#player walk input
func get_input():
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y+=1
		last_direction = "down";
	if Input.is_action_pressed("move_up"):
		velocity.y-=1
		last_direction = "up";
	if Input.is_action_pressed("move_left"):
		velocity.x-=1
		last_direction = "left";
	if Input.is_action_pressed("move_right"):
		velocity.x+=1
		last_direction = "right";
	if Input.is_action_just_pressed("attack") and !attack:
		attack = true;
		weapon_aread_origin();
		
		
	velocity = velocity.normalized() * speed

func weapon_aread_origin():
	_weapon_area.show()
	match last_direction:
		"down":
			_weapon_area.rotation_degrees = 30;
		"right":
			_weapon_area.rotation_degrees = -60;
		"left":
			_weapon_area.rotation_degrees = 120;
		"up":
			_weapon_area.rotation_degrees = 210;

	
	start_attack_angle = _weapon_area.rotation_degrees


func _physics_process(_delta):
	if is_dead:
		return
	get_input()
	if attack: 
		weapon_attack(_delta);
		
	
	velocity = move_and_slide(velocity * _delta)
	
func weapon_attack(_delta):
	_weapon_area.rotation_degrees += attack_speed * _delta;
	if _weapon_area.rotation_degrees - start_attack_angle > 90:
		attack = false;
		_weapon_area.hide();
		

#player walk_animation
func _move_animation():
#	
	if Input.is_action_pressed("move_down") and (_animated_sprite.get_animation() == "idle"):
		_animated_sprite.play("run_y_down")
	elif Input.is_action_just_released("move_down"):
		_animated_sprite.play("idle")
	if Input.is_action_pressed("move_right") and (_animated_sprite.get_animation() == "idle"):
		_animated_sprite.play("run_x_right")
	elif Input.is_action_just_released("move_right"):
		_animated_sprite.play("idle")
	if Input.is_action_pressed("move_up") and (_animated_sprite.get_animation() == "idle"):
		_animated_sprite.play("run_y_up")
	elif Input.is_action_just_released("move_up"):
		_animated_sprite.play("idle")
	if Input.is_action_pressed("move_left") and (_animated_sprite.get_animation() == "idle"):
		_animated_sprite.play("run_x_left")
		
	elif Input.is_action_just_released("move_left"):
		_animated_sprite.play("idle")
	
	

func _process(_delta):
	if (is_dead):
		_animated_sprite.play("die")
		return
	_move_animation()
	
	
func take_damage(damage):
	hp-=damage;
	print (hp)
	if hp <= 0:
		is_dead = true;

func _on_Weapon_body_entered(body:Node2D):
	if body.has_method("take_damage"):
		body.take_damage(2);
	pass 
