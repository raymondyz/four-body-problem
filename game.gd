extends Node2D

@export var ball_scene: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_piece"):
		var ball = ball_scene.instantiate()
		ball.global_position = get_global_mouse_position()
		add_child(ball)
		ball.linear_velocity = Vector2(100,100)
