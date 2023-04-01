extends Control

func _on_lv_updated(lv):
	$Label.text = str(lv);
