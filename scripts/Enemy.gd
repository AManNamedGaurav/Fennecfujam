extends KinematicBody2D

export var run_speed = 65 setget , get_run_speed

var velocity = Vector2.ZERO
var player = null

func get_run_speed():
	return run_speed

func _ready():
	pass



func _physics_process(delta):
	velocity = Vector2.ZERO


func _on_Area2D_body_entered(body):
	if body.name == "player":
		player = body


func _on_Area2D_body_exited(body):
	if body.name == "player":
		player = null
