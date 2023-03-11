extends KinematicBody2D

signal playerDead;

export (int) var speed = 200
export (int) var attack_speed = 200
export (int) var hp = 10;
export (int) var current_exp = 0;
export (int) var lv = 1; 
export (int) var next_lv_exp = 100
onready var _animated_sprite = $AnimatedSprite
onready var _weapon_collision = $Weapon/CollisionShape2D
var velocity = Vector2()
var last_direction = "down";
var can_attack = true;
var start_attack_angle=0;
var is_dead = false
var type_weapon = "sword"
var bounce_velocity = Vector2.ZERO;
var is_idle = true;
var weapon_scene = preload("res://scenes/player/sword.tscn")
var attack_rate = 0.5

func _ready():
	$HUD/HBoxContainer/Hp_bar._on_max_health_updated(hp)
	$HUD/HBoxContainer/Hp_bar._on_health_updated(hp)
	$HUD/HBoxContainer/Lv._on_lv_updated(lv)
	$HUD/VBoxContainer/Ex_bar._on_exp_updated(current_exp)
	$HUD/VBoxContainer/Ex_bar._on_next_exp_updated(next_lv_exp)
	#$HUD/DeathMenu.connect("playerDead", $HUD/DeathMenu, "show_death_screen")

#player walk input
func get_input():
	# TODO: переписать и сделать отдельным скрипт анимации 
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down") and can_attack:
		velocity.y+=1
		last_direction = "down";
	if Input.is_action_pressed("move_up") and can_attack:
		velocity.y-=1
		last_direction = "up";
	if Input.is_action_pressed("move_left") and can_attack:
		velocity.x-=1
		last_direction = "left";
	if Input.is_action_pressed("move_right") and can_attack:
		velocity.x+=1
		last_direction = "right";
	velocity = velocity.normalized() * speed;

func attack():
	#TODO: добавить анимацию атаки
	can_attack = false;
	var weapon = weapon_scene.instance()
	get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
	if type_weapon == "sword":
		set_sword_rotation()
	weapon.position = get_node("TurnAxis/CastPoint").position
	weapon.rotation = get_node("TurnAxis").rotation
	if type_weapon == "sword":
		add_child(weapon)
	yield(get_tree().create_timer(attack_rate), "timeout")
	can_attack = true
	weapon.queue_free()
#	match last_direction:
#		"down":
#			_animated_sprite.play("attack_down")
#			weapon.rotation_degrees = 30;
#		"right":
#			_animated_sprite.set_flip_h(true);
#			_animated_sprite.play("attack_x");
#			weapon.rotation_degrees = -60;
#		"left":
#			_animated_sprite.set_flip_h(false);
#			_animated_sprite.play("attack_x");
#			weapon.rotation_degrees = 120;
#		"up":
#			_animated_sprite.play("attack_up")
#			weapon.rotation_degrees = 210;
#	start_attack_angle = weapon.rotation_degrees
#	we

func set_sword_rotation():
	match last_direction:
		"down":
			get_node("TurnAxis").rotation_degrees = -270;
		"right":
			get_node("TurnAxis").rotation_degrees = 0;
		"left":
			get_node("TurnAxis").rotation_degrees = -180;
		"up":
			get_node("TurnAxis").rotation_degrees = -90;

func _physics_process(_delta):
	if is_dead:
		return
	get_input()
	
	#if attack: 
	#	weapon_attack();

	if bounce_velocity.length() >= 2:
		bounce_velocity += bounce_velocity.normalized() * -200;
		velocity = move_and_slide(bounce_velocity)
		return;
	velocity = move_and_slide(velocity)
	
#func weapon_attack():
#	_weapon_area.rotation_degrees += attack_speed;
#	if _weapon_area.rotation_degrees - start_attack_angle > 90:
#		attack = false;
#		_weapon_area.hide();
#		match last_direction:
#			"down":
#				_animated_sprite.play("idle_down")
#			"right":
#				_animated_sprite.set_flip_h(true);
#				_animated_sprite.play("idle_x");
#			"left":
#				_animated_sprite.set_flip_h(false);
#				_animated_sprite.play("idle_x");
#			"up":
#				_animated_sprite.play("idle_up")

#player walk_animation
func _move_animation():
#	TODO переделать 
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
	skill_loop()

func skill_loop():
	if Input.is_action_pressed("attack") and can_attack:
		attack();
	
	
func receive_damage(from, damage):
	hp-=damage;
	$HUD/HBoxContainer/Hp_bar._on_health_updated(hp);
	bounce_velocity = global_position.direction_to(from.global_position) * -1000;

	if hp <= 0 and !is_dead:
		is_dead = true;
		emit_signal("playerDead")
#
#func _on_Weapon_body_entered(body:Node2D):
#	if body.has_method("receive_damage"):
#		body.receive_damage(self, 2);
#	pass 
	
func get_exp(ex):
	current_exp += ex
	if current_exp >= next_lv_exp: 
		lv+=1
		current_exp -= next_lv_exp
		next_lv_exp *= 12
		next_lv_exp /= 10
		$HUD/VBoxContainer/Ex_bar._on_next_exp_updated(next_lv_exp)
		$HUD/HBoxContainer/Lv._on_lv_updated(lv)
	$HUD/VBoxContainer/Ex_bar._on_exp_updated(current_exp)
	
	
	
	
