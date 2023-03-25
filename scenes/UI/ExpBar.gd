extends TextureProgress

func _on_exp_updated(health):
	value = health;

func _on_next_exp_updated(max_health):
	max_value = max_health;
