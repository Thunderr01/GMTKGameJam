extends CanvasLayer

signal restart_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/FireAnimation.play("default")
	$Control/FireAnimation2.play("default")
	$Control/FireAnimation2.frame = 4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	restart_game.emit()
