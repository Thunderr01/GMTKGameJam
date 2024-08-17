extends CharacterBody2D

@export var speed = 400
@export var cables_handler: Node2D
var _current_connection_point: ConnectionPoint

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction.normalized() * speed

func connection_point_visible(connection_point: ConnectionPoint):
	_current_connection_point = connection_point

func check_point_connection():
	if  _current_connection_point and Input.is_action_just_pressed("GetConnection"):
		$ConnectionHandler.handle(_current_connection_point)

func check_cable_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().collision_layer == 8:
			$RopeBreaker.set_collision_point(collision.get_position())

func _physics_process(delta):
	get_input()
	move_and_slide()
	check_point_connection()
	check_cable_collision()
		
