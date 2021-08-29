extends KinematicBody2D

#configs
export var patrol_speed: int = 65
export var chase_speed: int = 65
export var has_xray: bool
export var mask_type: int = 0
export var vision_scale:int = 1

onready var player:Node2D = get_tree().get_current_scene().get_node("player")
onready var patrol_path: PathFollow2D = get_parent()
onready var map_navigation:Navigation2D = get_tree().get_current_scene().get_node("Navigation2D")

enum States {PATROLLING, IN_RANGE, CHASING, RETURNING}

signal game_over

var patrol_resume_pos: Vector2
var velocity = Vector2.ZERO
var state = States.PATROLLING
var player_in_range: bool = false


func _ready():
	$Vision.set_scale($Vision.get_scale()*vision_scale)


func _physics_process(delta):
	print(global_rotation_degrees)
	match state:
		States.PATROLLING:
			print("patrolling")
			if _can_see_player():
				patrol_resume_pos = get_global_position()
				state = States.CHASING
			else:
				var curr_offset = patrol_path.get_offset()
				#lookahead to calculate next frame's position
				patrol_path.set_offset(curr_offset + patrol_speed*delta)
				var next_position = get_global_position()
				#come back and look at next position
				patrol_path.set_offset(curr_offset)
				look_at(next_position)
				#continue moving forward on curve
				patrol_path.set_offset(curr_offset + patrol_speed*delta)
				
		States.CHASING:
			print("chasing")
			if _can_see_player():
				_move_towards_with_speed(player.get_global_position(), chase_speed, delta)
			else:
				state = States.RETURNING
		States.RETURNING:
			print("returning")
			if _can_see_player():
				state = States.CHASING
			else:
				var position = get_global_position()
				if position.is_equal_approx(patrol_resume_pos):
					state = States.PATROLLING
				else:
					_move_towards_with_speed(patrol_resume_pos, patrol_speed, delta)
	

func _move_towards_with_speed(dest: Vector2, speed: int, delta: float) -> void:
	var path_to_destination = map_navigation.get_simple_path(get_global_position(), dest)
	var move_distance = speed*delta
	var starting_point = get_global_position()
	
	for point in range(path_to_destination.size()):
		var distance_to_next_point = starting_point.distance_to(path_to_destination[0])
		if move_distance <= distance_to_next_point:
			#face destination
			var lerped_dest = starting_point.linear_interpolate(path_to_destination[0], move_distance/distance_to_next_point)
			look_at(lerped_dest)
			var lin_vel = (lerped_dest - get_global_position()).normalized() * speed
			move_and_slide(lin_vel)
			return
		move_distance -= distance_to_next_point
		starting_point = path_to_destination[0]
		path_to_destination.remove(0)
	#exhausted all path points but still have move_distance
	#teleport
	set_global_position(dest)

func _can_see_player() -> bool:
	if player_in_range:
		if player.get_mask_type() == mask_type:
			return false
		elif has_xray:
			return true
		else:
			var space_state = get_world_2d().direct_space_state
			var sight_check = space_state.intersect_ray(position, player.position, [self], collision_mask)
			if sight_check:
				if sight_check.collider.name == "player":
					return true
	return false





# event handlers
func _on_Area2D_body_entered(body):
	if body == player:
		player_in_range = true


func _on_Area2D_body_exited(body):
	if body == player:
		player_in_range = false
		


#func _check_sight():
#	if player_in_range:
#		var space_state = get_world_2d().direct_space_state
#		var sight_check = space_state.intersect_ray(position, player.position, [self], collision_mask)
#		if sight_check:
#			if sight_check.collider.name == "player":
#				player_in_sight = true
#				player_seen = true
#				player_position = player.get_global_position()
#				state = "Attack"
#			else:
#				player_in_sight = false
#				if player_seen:
#					state = "Search"
#				else:
#					state = "Patrol"
				
	

