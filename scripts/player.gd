extends KinematicBody2D

export var speed = 150
export var friction = 1
export var acceleration = 1

enum FacingDirection {LEFT, RIGHT, DOWN, UP}

var velocity = Vector2()
var masks = 0
var facing_dir = FacingDirection.RIGHT
#func _ready():
#
#	pass


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
	var direction:Vector2 = get_input()
	if direction.length() > 0:
		if direction.x > 0:
			if facing_dir == FacingDirection.LEFT:
				$AnimatedSprite.play("left_to_right")
			else:
				$AnimatedSprite.play("walk_right")
			facing_dir = FacingDirection.RIGHT
		elif direction.x < 0:
			if facing_dir == FacingDirection.RIGHT:
				$AnimatedSprite.play("right_to_left")
			else:
				$AnimatedSprite.play("walk_left")
			facing_dir = FacingDirection.LEFT
		elif direction.y > 0:
			$AnimatedSprite.play("walk_down")
			facing_dir = FacingDirection.DOWN
		elif direction. y < 0:
			$AnimatedSprite.play("walk_up")
			facing_dir = FacingDirection.UP
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		#enter idle whichever direction player was facing
		match facing_dir:
			FacingDirection.LEFT:
				$AnimatedSprite.play("idle_left")
			FacingDirection.RIGHT:
				$AnimatedSprite.play("idle_right")
			FacingDirection.UP:
				$AnimatedSprite.play("idle_up")
			FacingDirection.DOWN:
				$AnimatedSprite.play("idle_down")
		velocity = lerp(velocity, Vector2.ZERO, friction)
	 
	velocity = move_and_slide(velocity)
	
	masks = min(masks,9)


func _on_AnimatedSprite_animation_finished():
	#play walk_right if animation was left_to_right
	if $AnimatedSprite.get_animation() == "left_to_right":
		$AnimatedSprite.play("walk_right")
	#play walk_left if animation was right_to_left
	if $AnimatedSprite.get_animation() == "right_to_left":
		$AnimatedSprite.play("walk_left")
