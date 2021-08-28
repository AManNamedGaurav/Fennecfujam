extends KinematicBody2D

export var speed = 150
export var friction = 1
export var acceleration = 1

var velocity = Vector2()
var masks = 0


func _ready():
	pass


func get_input():
	var input = Vector2()
	if Input.is_action_pressed("right"):
		input.x += 1
		#$Plant_location/Sprite.flip_h = false
		#$Position2D.position *= Vector2(1,-1)
	if Input.is_action_pressed("left"):
		input.x -= 1
		#$Plant_location/Sprite.flip_h = true
		#$Position2D.position *= Vector2(-1,1)
	if Input.is_action_pressed("down"):
		input.y += 1
		
		#$Position2D.position *= Vector2(1,1)
	if Input.is_action_pressed("up"):
		input.y -= 1
		
		#$Position2D.position *= Vector2(1,-1)
	return input


func _physics_process(delta):
	var direction = get_input()
	
	
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	 
	velocity = move_and_slide(velocity)
	
	masks = min(masks,9)
