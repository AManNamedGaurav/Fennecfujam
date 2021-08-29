extends Area2D

export var mask_type:int = 0
signal mask_collected(mask_type)

func _ready():
	pass


func _on_mask_body_entered(body):
	if "player" in body.name:
		emit_signal("mask_collected", mask_type)
		queue_free()
