extends Level

func _ready():
	super()
	
func save():
	#var save_nodes = get_tree().get_nodes_in_group("LevelPersist")
	#for save_node in save_nodes:
		#print(save_node)
		
	var trees = save_trees()
	var chests = save_chests()
		
	var save_dict = {
		"filename" : get_scene_file_path(),
		"node_path" : get_path(),
		"name" : name,
		"trees" : trees,
		"chests" : chests,
		#"bonfires" : bonfires,
		#"enemies" : enemies
	}
	return save_dict


func save_trees():
	var save_dict = {}
	for tree in $Trees.get_children():
		save_dict[tree.name] = tree.save()
	return save_dict
	
func save_chests():
	var save_dict = {}
	for chest in $Chests.get_children():
		save_dict[chest.name] = chest.save()
	return save_dict
