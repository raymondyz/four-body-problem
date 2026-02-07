extends RigidBody2D

var low_velocity_timer: float = 0.0
var freeze_time: float = 1.0
var center_velocity_threshold: float = 3.0

@export var p1_color: Color = Color.WHITE
@export var p2_color: Color = Color.BLACK

@onready var connect_area_2d: Area2D = $ConnectArea2D

var neighbors: Array[RigidBody2D] = []
@export var line_color: Color = Color.RED

func _draw() -> void:
	for neighbor in neighbors:
		if is_instance_valid(neighbor):
			var local_target = to_local(neighbor.global_position)
			draw_line(Vector2.ZERO, local_target, line_color, 2.0)


func _process(_delta: float) -> void:
	queue_redraw()
	


func _physics_process(_delta: float) -> void:
	#var velocity_threshold = 1.0
	var gravity_strength = 980
	
	apply_central_force(global_position.direction_to(Vector2.ZERO) * gravity_strength)
	
	
	#if linear_velocity.length() < velocity_threshold:
		#low_velocity_timer += delta
		#if low_velocity_timer >= freeze_time:
			#freeze = true
	#else:
		#low_velocity_timer = 0.0

func _on_body_entered(body):
	var is_same_color: bool = body.is_in_group("Black")
	if is_in_group("White"):
		is_same_color = body.is_in_group("White")
	
	
	print("Detected body is same color: ", is_same_color)



func _ready():
	connect_area_2d.body_entered.connect(_on_body_entered)
	
	
	if (Global.is_white_turn):
		modulate = p1_color
		add_to_group("White")
	else:
		modulate = p2_color
		add_to_group("Black")
	
	Global.is_white_turn = !Global.is_white_turn
	
	sleeping = false
	#linear_velocity = Vector2(100,100)
