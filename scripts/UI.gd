extends CanvasLayer




func _process(delta):
	$Control/mask.frame = get_node("../player").masks
	
