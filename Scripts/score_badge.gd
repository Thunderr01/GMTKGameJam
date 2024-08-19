extends Node2D

var plus_user_texture = load("res://Art/plus_user.png")
var minus_user_texture = load("res://Art/minus_user.png")

func set_badge_to_plus_user():
	$Sprite2D.texture = plus_user_texture
	
func set_badge_to_minus_user():
	$Sprite2D.texture = minus_user_texture

func _ready():
	$AnimationPlayer.play("fly")
