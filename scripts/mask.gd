extends Area2D

func _ready():
	pass


func _on_mask_body_entered(body):
	if "player" in body.name && body.get("masks") < 9:
		
		body.masks += 1
		queue_free()
