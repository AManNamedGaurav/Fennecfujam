extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var follow = get_node("PathFollow2D")
var speed setget set_speed


func set_speed(var sp):
	speed = sp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speed > 0:
		follow.set_offset(follow.get_offset() + speed*delta)
