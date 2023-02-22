extends Node

export(String, FILE, ".dat") var saveFilePath = "user://save.dat"
export(String) var saveGroup = "Persist"


func save_data():
	var saveFile = File.new()
	saveFile.open(saveFilePath, File.WRITE)
	
	var nodeList = get_tree().get_nodes_in_group(saveGroup)
	print(nodeList)
	for node in nodeList:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		if !node.has_method("_save"):
			print("persistent node '%s' is missing a _save() function, skipped" % node.name)
			continue
		
		var data = node.save()
		print(data)
		saveFile.save_var(data)
	
	saveFile.close()

func load_game():
	var saveFile = File.new()
	if not saveFile.file_exists(saveFilePath):
		return
	
	var nodeList = get_tree().get_nodes_in_group(saveGroup)
	for node in nodeList:
		node.queue_free()
	
	saveFile.open(saveFilePath, File.READ)
	
	while saveFile.get_position() < saveFile.get_len():
		var data = parse_json(saveFile.get_line())
		var node = load(data["filename"]).instance()
		if !node.has_method("_load_from"):
			print("persistent node '%s' is missing a _load_from(dict) function, skipped" % node.name)
			continue
		get_node(data["parent"]).add_child(node)
		node.load_from(data)
	
	saveFile.close()

func _on_PauseMenu_gameExit():
	save_data()

func _on_level_resumed():
	load_game()
