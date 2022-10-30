extends HBoxContainer

signal resolution_changed(res)

export(Array, String) var resolutions = ["640x480", "1280x720", "1920x1080"]

onready var selector: OptionButton = $OptionButton

func _ready() -> void:
	for idx in range(resolutions.size()):
		selector.add_item(resolutions[idx], idx)

func set_value(res: String) -> void:
	var idx = resolutions.find(res, 0)
	selector.select(idx)

func _on_resolution_item_selected(index: int) -> void:
	emit_signal("resolution_changed", selector.get_item_text(index))
