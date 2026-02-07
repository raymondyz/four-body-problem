extends RigidBody2D

var low_velocity_timer: float = 0.0
var freeze_time: float = 1.0
var center_velocity_threshold: float = 3.0

@export var p1_color: Color = Color.WHITE
@export var p2_color: Color = Color.BLACK

@onready var connect_collision_shape_2d = $ConnectCollisionShape2D

func _physics_process(delta: float) -> void:
	var velocity_threshold = 1.0
	var gravity_strength = 980
	
	if global_position.length() > 5:
		apply_central_force(global_position.direction_to(Vector2.ZERO) * gravity_strength)
	elif (linear_velocity.length() < center_velocity_threshold):
		freeze = true
	
	if linear_velocity.length() < velocity_threshold:
		low_velocity_timer += delta
		if low_velocity_timer >= freeze_time:
			freeze = true
	else:
		low_velocity_timer = 0.0


func _ready():
	if (Global.is_white_turn):
		modulate = p1_color
		add_to_group("White")
	else:
		modulate = p2_color
		add_to_group("Black")
	
	Global.is_white_turn = !Global.is_white_turn
	
	sleeping = false
	#linear_velocity = Vector2(100,100)
