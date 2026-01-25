extends Node

var current_scene = null
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path, spawn_index):
	call_deferred("_deferred_switch_scene", res_path, spawn_index)
	
func _deferred_switch_scene(res_path, spawn_index):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	var player : Player= get_tree().get_nodes_in_group("player")[0]
	var portals = get_tree().get_nodes_in_group("portals")
	if spawn_index==0:
		return
	for portal : Portal in portals:
		if portal.spwan_index == spawn_index:
			player.position = portal.position
			for node in player.get_children():
				if is_instance_of(node,Camera2D):
					#node.offset = Vector2.UP * 80
					node.reset_smoothing()
					break
			break
