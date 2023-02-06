extends KinematicBody2D

export (int) var speed = 200
export (int) var attack_speed = 200
export (int) var hp = 10;
export (int) var damage = 2;
export (int) var level = 1; 
export (int) var experienceRequired = 100;
export (int) var experience = 0;
var velocity = Vector2()
var move_direction = Vector2()
var attack = false;
var start_attack_angle=0;
var is_dead = false
var bounce_velocity = Vector2.ZERO; 
var animDirection = "down"
var animMode = "idle"
var animation

onready var _animated_sprite = $AnimatedSprite
onready var _weapon_area = $Weapon
onready var _weapon_collision = $Weapon/CollisionShape2D

func _ready():
	_weapon_area.hide();
	$HUD/Hp_bar._on_max_health_updated(hp)
	$HUD/Hp_bar._on_health_updated(hp)

func _physics_process(_delta):
	if is_dead:
		return
	get_input()
	if attack: 
		weapon_attack();
	if bounce_velocity.length() >= 2:
		bounce_velocity += bounce_velocity.normalized() * -200;
		velocity = move_and_slide(bounce_velocity)
		return;
	velocity = move_and_slide(velocity)

func _process(_delta):
	if (is_dead):
		return
	animation_loop()
	
	
func get_input() -> void:
	velocity = Vector2.ZERO
	if !attack:
		movement_loop()
		if Input.is_action_just_pressed("attack"):
			attack = true;
			weapon_aread_origin();

#player walk input
func movement_loop() -> void:
	var left = -int(Input.is_action_pressed("move_left"))
	var up = -int(Input.is_action_pressed("move_up"))
	var down = int(Input.is_action_pressed("move_down"))
	var right = int(Input.is_action_pressed("move_right"))
	move_direction.x = left + right;
	move_direction.y = up + down;
	velocity = move_direction.normalized() * speed;

func animation_loop() -> void:
	_move_animation()
	animation=animMode+"_"+animDirection;
	_animated_sprite.play(animation);

func weapon_aread_origin() -> void:
	_weapon_area.show()
	match move_direction:
		Vector2(0,1):
			_animated_sprite.play("attack_down")
			_weapon_area.rotation_degrees = 30;
		Vector2(1,0):
			_animated_sprite.set_flip_h(true);
			_animated_sprite.play("attack_x");
			_weapon_area.rotation_degrees = -60;
		Vector2(-1,0):
			_animated_sprite.set_flip_h(false);
			_animated_sprite.play("attack_x");
			_weapon_area.rotation_degrees = 120;
		Vector2(0,-1):
			_animated_sprite.play("attack_up")
			_weapon_area.rotation_degrees = 210;
	start_attack_angle = _weapon_area.rotation_degrees

	
func weapon_attack() -> void:
	_weapon_area.rotation_degrees += attack_speed;
	if _weapon_area.rotation_degrees - start_attack_angle > 90:
		attack = false;
		_weapon_area.hide();
		match move_direction:
			Vector2(0,1):
				_animated_sprite.play("idle_down")
			Vector2(1,0):
				_animated_sprite.set_flip_h(true);
				_animated_sprite.play("idle_x");
			Vector2(-1,0):
				_animated_sprite.set_flip_h(false);
				_animated_sprite.play("idle_x");
			Vector2(0,-1):
				_animated_sprite.play("idle_up")

#player walk_animation
func _move_animation() -> void:
	match move_direction.y:
		-1.0: 
			animDirection ="up";
		1.0: 
			animDirection="down";
	match move_direction.x:
		-1.0: 
			animDirection ="left";
		1.0: 
			animDirection="right";
	if move_direction != Vector2.ZERO:
		animMode = "run"
	else:
		animMode ="idle"

	
func receive_damage(from, damage) -> void:
	hp-=damage;
	$HUD/Hp_bar._on_health_updated(hp);
	bounce_velocity = global_position.direction_to(from.global_position) * -1000;
	if hp <= 0:
		is_dead = true;

func get_exp(experienceGained) -> void:
	experience += experienceGained;
	while experience >= experienceRequired: 
		level_up();
	print(experience)
	print(level)

func level_up():
	level+=1;
	experience -= experienceRequired;
	experienceRequired  *= 1.4;
	pass	

func _on_Weapon_body_entered(body:Node2D) -> void:
	if !attack:
		return;
	if body.has_method("receive_damage"):
		body.receive_damage(self, 2);
	pass 
