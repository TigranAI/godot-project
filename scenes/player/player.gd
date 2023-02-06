extends KinematicBody2D

signal playerDead;

export (int) var speed = 200
export (int) var attack_speed = 200
export (int) var hp = 10;
onready var _animated_sprite = $AnimatedSprite
onready var _weapon_area = $Weapon
onready var _weapon_collision = $Weapon/CollisionShape2D
var velocity = Vector2()
var last_direction = "down";
var attack = false;
var start_attack_angle=0;
var is_dead = false
var bounce_velocity = Vector2.ZERO;
var is_idle = true;

func _ready():
	_weapon_area.hide();
	$HUD/Hp_bar._on_max_health_updated(hp)
	$HUD/Hp_bar._on_health_updated(hp)
	#$HUD/DeathMenu.connect("playerDead", $HUD/DeathMenu, "show_death_screen")

#player walk input
func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down") and !attack:
		velocity.y+=1
		last_direction = "down";
	if Input.is_action_pressed("move_up") and !attack:
		velocity.y-=1
		last_direction = "up";
	if Input.is_action_pressed("move_left") and !attack:
		velocity.x-=1
		last_direction = "left";
	if Input.is_action_pressed("move_right") and !attack:
		velocity.x+=1
		last_direction = "right";
	if Input.is_action_just_pressed("attack") and !attack:
		attack = true;
		weapon_aread_origin();
		
	velocity = velocity.normalized() * speed;

func weapon_aread_origin():
	_weapon_area.show()
	match last_direction:
		"down":
			_animated_sprite.play("attack_down")
			_weapon_area.rotation_degrees = 30;
		"right":
			_animated_sprite.set_flip_h(true);
			_animated_sprite.play("attack_x");
			_weapon_area.rotation_degrees = -60;
		"left":
			_animated_sprite.set_flip_h(false);
			_animated_sprite.play("attack_x");
			_weapon_area.rotation_degrees = 120;
		"up":
			_animated_sprite.play("attack_up")
			_weapon_area.rotation_degrees = 210;
	start_attack_angle = _weapon_area.rotation_degrees


func _physics_process(_delta):
	if is_dead:
		return
	get_input()
	if attack: 
		weapon_attack();
#	if velocity != Vector2.ZERO:
#		print (velocity);

	

	if bounce_velocity.length() >= 2:
		bounce_velocity += bounce_velocity.normalized() * -200;
		velocity = move_and_slide(bounce_velocity)
		return;
	velocity = move_and_slide(velocity)
	
func weapon_attack():
	_weapon_area.rotation_degrees += attack_speed;
	if _weapon_area.rotation_degrees - start_attack_angle > 90:
		attack = false;
		_weapon_area.hide();
		match last_direction:
			"down":
				_animated_sprite.play("idle_down")
			"right":
				_animated_sprite.set_flip_h(true);
				_animated_sprite.play("idle_x");
			"left":
				_animated_sprite.set_flip_h(false);
				_animated_sprite.play("idle_x");
			"up":
				_animated_sprite.play("idle_up")

#player walk_animation
func _move_animation():
#	
	if Input.is_action_pressed("move_down") and is_idle:
		is_idle = false; 
		_animated_sprite.play("run_down")
	elif Input.is_action_just_released("move_down"):
		is_idle = true;
		_animated_sprite.play("idle_down")
	if Input.is_action_pressed("move_right") and is_idle:
		is_idle = false; 
		_animated_sprite.set_flip_h(true)
		_animated_sprite.play("run_x")
	elif Input.is_action_just_released("move_right"):
		is_idle = true;
		_animated_sprite.play("idle_x")
	if Input.is_action_pressed("move_up") and is_idle:
		is_idle = false;
		_animated_sprite.play("run_up")
	elif Input.is_action_just_released("move_up"):
		is_idle = true;
		_animated_sprite.play("idle_up")
	if Input.is_action_pressed("move_left") and is_idle:
		is_idle = false;
		_animated_sprite.set_flip_h(false)
		_animated_sprite.play("run_x")
	elif Input.is_action_just_released("move_left"):
		is_idle = true;
		_animated_sprite.play("idle_x")
	
	

func _process(_delta):
	if (is_dead):
		#_animated_sprite.play("die")
		return
	_move_animation()
	
	
func receive_damage(from, damage):
	hp-=damage;
	$HUD/Hp_bar._on_health_updated(hp);
	bounce_velocity = global_position.direction_to(from.global_position) * -1000;

	if hp <= 0 and !is_dead:
		is_dead = true;
		emit_signal("playerDead")

func _on_Weapon_body_entered(body:Node2D):
	if !attack:
		return;
	if body.has_method("receive_damage"):
		body.receive_damage(self, 2);
	pass 
