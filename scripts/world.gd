extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/Control/face_location/mask_0.hide()
	$UI/Control/face_location/mask_1.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_mask_mask_collected(mask_type):
	match mask_type:
		0:
			$UI/Control/face_location/mask_1.hide()
			$UI/Control/face_location/mask_0.show()
			$player.set_mask_type(0)
		1:
			$UI/Control/face_location/mask_0.hide()
			$UI/Control/face_location/mask_1.show()
			$player.set_mask_type(1)
	pass # Replace with function body.


func _on_player_game_over():
	get_tree().reload_current_scene()
	pass # Replace with function body.
