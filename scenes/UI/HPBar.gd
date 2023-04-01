extends TextureProgress

func _on_health_updated(health):
	value = health;

func _on_max_health_updated(max_health):
	 max_value = max_health;
