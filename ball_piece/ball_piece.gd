extends RigidBody2D


@export var connecting_line:PackedScene
var connecting_line_instances:Array = []

var connections = {} # Key: body, Value: Line2D instance


var low_velocity_timer: float = 0.0
var freeze_time: float = 1.0
var center_velocity_threshold: float = 3.0
@export var p1_color: Color = Color.WHITE
@export var p2_color: Color = Color.BLACK
@onready var connect_area_2d: Area2D = $ConnectArea2D
@export var line_color: Color = Color.RED



func draw_connecting_line() -> void:
	for body in connections:
		if is_instance_valid(body):
			connections[body].points = [Vector2.ZERO, to_local(body.global_position)]
	


func _process(_delta: float) -> void:
	draw_connecting_line()
	


func _physics_process(_delta: float) -> void:
	#var velocity_threshold = 1.0
	var gravity_strength = 980
	
	apply_central_force(global_position.direction_to(Vector2.ZERO) * gravity_strength)
	

func _on_body_entered(body):
	
	if not (body.is_in_group("White") or body.is_in_group("Black")):
		return
	var same_group = (is_in_group("White") and body.is_in_group("White")) or (is_in_group("Black") and body.is_in_group("Black"))
	
	if same_group and !(connections.has(body)):
		# establish a connection:
		var line = connecting_line.instantiate()
		line.self_modulate = line_color
		add_child(line)
		connections[body] = line
	

func _on_body_exited(body):
	# Remove from connected bodies if present
	if connections.has(body):
		var line = connections[body]
		line.queue_free()
		connections.erase(body)

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
