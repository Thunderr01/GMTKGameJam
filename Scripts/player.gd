extends CharacterBody2D

@export var regular_speed = 400
@export var jump_speed = 450
@export var cables_handler: Node2D
var _current_connection_point: ConnectionPoint
var _should_jump: bool = false
var speed = regular_speed

func _ready():
	$AnimatedSprite2D.play("standing")

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction.normalized() * speed
	
	if Input.is_action_just_pressed("Jump"):
		_should_jump = true
		speed = jump_speed
		collision_mask ^= 8
		z_index = 20
		$RopeBreaker.monitoring = false
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "position", Vector2(0, -200), 0.15)
		tween.chain().tween_property($AnimatedSprite2D, "position", Vector2(0, 0), 0.15)
		tween.finished.connect(jump_tween_finished)


func jump_tween_finished():
	speed = regular_speed
	collision_mask ^= 8
	z_index = 0
	$RopeBreaker.monitoring = true


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
	handle_animation()

func handle_animation():
	if !velocity:
		$AnimatedSprite2D.stop()
		return
	
	if velocity.y < 0:
		$AnimatedSprite2D.play("walking_back")
	else:
		$AnimatedSprite2D.play("walking")
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
