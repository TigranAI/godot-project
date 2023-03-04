extends Control

func _on_lv_updated(lv):
	$Label.text = str(lv);

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
