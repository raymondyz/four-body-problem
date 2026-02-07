extends RigidBody2D

var low_velocity_timer: float = 0.0
var freeze_time: float = 1.0
var center_velocity_threshold: float = 3.0

@export var p1_color: Color = Color.WHITE
@export var p2_color: Color = Color.BLACK

@onready var connect_area_2d: Area2D = $ConnectArea2D

var connected_bodies: Array = []
@export var line_color: Color = Color.RED

func _draw() -> void:
	for body in connected_bodies:
		if is_instance_valid(body):
			var local_target = to_local(body.global_position)
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
	
	if not (body.is_in_group("White") or body.is_in_group("Black")):
		return
	var same_group = (is_in_group("White") and body.is_in_group("White")) or (is_in_group("Black") and body.is_in_group("Black"))
	
	if same_group and body not in connected_bodies:
		connected_bodies.append(body)
		body.connected_bodies.append(self)
	

func _on_body_exited(body):
	# Remove from connected bodies if present
	if body in connected_bodies:
		connected_bodies.erase(body)
		body.connected_bodies.erase(self)

@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready():
	connect_area_2d.body_entered.connect(_on_body_entered)
	connect_area_2d.body_exited.connect(_on_body_exited)
	
	
	if (Global.is_white_turn):
		polygon_2d.self_modulate = p1_color
		add_to_group("White")
	else:
		polygon_2d.self_modulate = p2_color
		add_to_group("Black")
	
	Global.is_white_turn = !Global.is_white_turn
	
	sleeping = false
	#linear_velocity = Vector2(100,100)
