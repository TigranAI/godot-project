extends KinematicBody2D

signal playerDead;

export (int) var speed = 200
export (int) var attack_speed = 200
export (int) var hp = 10;
export (int) var current_exp = 0;
export (int) var lv = 1; 
export (int) var next_lv_exp = 100
export (float) var attack_rate = 0.5
onready var _animated_sprite = $AnimatedSprite
var velocity = Vector2()
var last_direction = Vector2.DOWN;
var can_attack = true;
var is_dead = false
var type_attack = "sword"
var bounce_velocity = Vector2.ZERO;
var weapon_scene = preload("res://scenes/player/Sword.tscn")
var attack_in_process = false 
var weapon
var last_direction_name = {
	Vector2(1, 1):"right", Vector2(1, -1):"right", Vector2(1, 0):"right",
	Vector2(-1, -1):"left", Vector2(-1, 1):"left", Vector2(-1, 0):"left",
	Vector2.DOWN:"down", Vector2.UP:"up",
	Vector2.ZERO:"down"
}

func _ready():
	$HUD/HBoxContainer/Hp_bar._on_max_health_updated(hp)
	$HUD/HBoxContainer/Hp_bar._on_health_updated(hp)
	$HUD/HBoxContainer/Lv._on_lv_updated(lv)
	$HUD/VBoxContainer/Ex_bar._on_exp_updated(current_exp)
	$HUD/VBoxContainer/Ex_bar._on_next_exp_updated(next_lv_exp)
	#$HUD/DeathMenu.connect("playerDead", $HUD/DeathMenu, "show_death_screen")

#player walk input
func get_input():
	velocity = Vector2.ZERO
	if !attack_in_process:
		if Input.is_action_pressed("move_down"):
			velocity.y=1
		if Input.is_action_pressed("move_up"):
			velocity.y=-1
		if Input.is_action_pressed("move_left") :
			velocity.x=-1
		if Input.is_action_pressed("move_right"):
			velocity.x=1
	if velocity != Vector2.ZERO:
		last_direction = velocity
	velocity = velocity.normalized() * speed;

func attack():
	can_attack = false;
	match type_attack:
		"sword": 
			sword_attack()

func sword_attack():
	weapon = weapon_scene.instance()
	weapon.position = $TurnAxis.position
	add_child(weapon)
	weapon.attack(last_direction)
	attack_in_process = true
	_animated_sprite.play("attack_"+last_direction_name[last_direction])
	yield(get_tree().create_timer(attack_rate), "timeout")
	can_attack = true


func _physics_process(_delta):
	if !is_dead:
		get_input()
		if bounce_velocity.length() >= 2:
			bounce_velocity += bounce_velocity.normalized() * -200;
			velocity = move_and_slide(bounce_velocity)
			return;
		velocity = move_and_slide(velocity)
	
	
#player walk_animation
func _move_animation():
	if velocity != Vector2.ZERO and !attack_in_process:
		_animated_sprite.play("run_"+last_direction_name[last_direction])
	elif !attack_in_process:
		_animated_sprite.play("idle_"+last_direction_name[last_direction])
	

func _process(_delta):
	if !is_dead:
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
	
func _on_AnimatedSprite_animation_finished():
	if attack_in_process:
		attack_in_process = false
		weapon.queue_free()
