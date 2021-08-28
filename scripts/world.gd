extends Node2D

export (PackedScene) var enemy:PackedScene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_add_enemies_to_paths()

func _add_enemies_to_paths():
	#add an enemy to each enemy path in scene
	var enemy_paths = get_tree().get_nodes_in_group("enemy_paths")
	for path in enemy_paths:
		var enemy_instance:Node = enemy.instance()
		#add enemy instance to pathfollow child of path (should only be one pathfollow)
		for child in path.get_children():
			if child is PathFollow2D:
				child.add_child(enemy_instance)
				path.set_speed(enemy_instance.get_run_speed())
				break


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
