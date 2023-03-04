extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _on_exp_updated(health):
	value = health;

func _on_next_exp_updated(max_health):
	 max_value = max_health;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
