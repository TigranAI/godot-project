extends Node2D

var enemy_array = []
var built = false
var enemy
var ready = true

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * 300 #GameData.tower_data[self.get_name()]["range"] Нужно брать радиус из общего скрипта для башень

func _physics_process(delta):
	if enemy_array.size() != 0 :
		print()
		enemy = enemy_array[0]
		turn()
		if ready:
			fire()
	else:
		enemy = null
	
func turn():
	get_node("Gun").look_at(enemy.position)
	
func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire():
	print("good")
	ready = false
	enemy.receive_damage(self, 5)	
	yield(get_tree().create_timer(1), "timeout") 
	#enemy.on_hit(GameData.tower_data[type]["damdge"]) Берем урон из общего скрипта для башень
	#yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout") Как я понял, частота стрельбы из того же скрипта башень
	ready = true

func _on_Range_body_entered(body):
	print("some_enter")
	if body.is_in_group("TestEnemyGroup"):
		enemy_array.append(body)


func _on_Range_body_exited(body):
	print("exited")
	enemy_array.erase(body)
